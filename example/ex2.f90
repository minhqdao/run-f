program ex_2
  use run_f, only: run
  implicit none

  character(:), allocatable :: output
  character(*), parameter :: command = 'xyzabc'
  logical :: has_error

  output = run(command, has_error, print_cmd=.true.)

  if (has_error) then
    print *, 'Error executing command: ', command
    stop 1
  end if

end
