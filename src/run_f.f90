module run_f
  use, intrinsic :: iso_c_binding, only: c_ptr, c_char, c_int, c_null_ptr, &
                                       & c_null_char, c_associated
  implicit none
  private

  public :: run

  interface
    function popen(cmd, mode) bind(C, name='popen')
      import :: c_char, c_ptr
      character(kind=c_char), dimension(*) :: cmd
      character(kind=c_char), dimension(*) :: mode
      type(c_ptr) :: popen
    end

    function fgets(str, size, stream) bind(C, name='fgets')
      import :: c_char, c_ptr, c_int
      character(kind=c_char), dimension(*) :: str
      integer(kind=c_int), value :: size
      type(c_ptr), value :: stream
      type(c_ptr) :: fgets
    end

    function pclose(stream) bind(C, name='pclose')
      import :: c_ptr, c_int
      type(c_ptr), value :: stream
      integer(c_int) :: pclose
    end
  end interface

contains

  !> Convert a C string to a Fortran string.
  pure function c2f(c) result(f)
    character(len=*), intent(in) :: c
    character(len=:), allocatable :: f

    integer :: i

    i = index(c, c_null_char)

    if (i <= 0) then
      f = c
    else if (i == 1) then
      f = ''
    else if (i > 1) then
      f = c(1:i - 1)
    end if
  end

  !> Run a command in the command line and return the result as a string.
  function run(cmd, has_error, print_cmd) result(str)
    !> The command to run in the command line.
    character(len=*), intent(in) :: cmd

    !> True if running the command results in an error.
    logical, optional, intent(out) :: has_error

    !> Whether the command is printed to the command line before it is executed.
    logical, optional, intent(in) :: print_cmd

    !> Stores the result of the command.
    character(len=:), allocatable :: str

    integer, parameter :: buffer_length = 1024

    type(c_ptr) :: handle
    integer(c_int) :: istat
    character(kind=c_char, len=buffer_length) :: line

    if (present(print_cmd)) then
      if (print_cmd) print *, 'Running command: ', cmd
    end if

    if (present(has_error)) has_error = .false.

    str = ''
    handle = c_null_ptr
    handle = popen(cmd//c_null_char, 'r'//c_null_char)

    if (.not. c_associated(handle)) then
      if (present(has_error)) has_error = .true.; return
    end if

    do while (c_associated(fgets(line, buffer_length, handle)))
      str = str//c2f(line)
    end do

    istat = pclose(handle)
    if (present(has_error)) has_error = istat /= 0
  end
end
