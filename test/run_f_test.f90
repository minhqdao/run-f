program run_f_test
  use run_f, only: run
  implicit none

  character(:), allocatable :: str
  logical :: has_error

  str = run('')
  if (str /= '') call fail('Empty command has output (no error handling).')

  str = run('abc')
  if (str /= '') call fail("Invalid command 'abc' has output (no error handling).")

  str = run('.')
  if (str /= '') call fail("Invalid command '.' has output (no error handling).")

  str = run('', has_error)
  if (str /= '') call fail('Empty command has output.')
  if (has_error) call fail('Empty command has error.')

  str = run('whoami')
  if (str == '') call fail('whoami has no output (no error handling).')

  str = run('whoami -x')
  if (str /= '') call fail('whoami with invalid option has output (no error handling).')

  str = run('whoami xyz')
  if (str /= '') call fail('whoami with invalid argument has output (no error handling).')

  str = run('whoami', has_error)
  if (str == '') call fail('whoami has no output.')
  if (has_error) call fail('whoami failed.')

  str = run('whoami', has_error, print_cmd=.false.)
  if (str == '') call fail('whoami has no output (no print).')
  if (has_error) call fail('whoami failed.')

  str = run('whoami', has_error, print_cmd=.true.)
  if (str == '') call fail('whoami has no output (with print).')
  if (has_error) call fail('whoami failed.')

  str = run('whoami -x', has_error)
  if (str /= '') call fail('whoami with invalid option has output.')
  if (.not. has_error) call fail('whoami with invalid option did not fail.')

  str = run('whoami xyz', has_error)
  if (str /= '') call fail('whoami with invalid argument has output.')
  if (.not. has_error) call fail('whoami with invalid argument did not fail.')

  str = run('abc', has_error)
  if (str /= '') call fail("Invalid command 'abc' has output.")
  if (.not. has_error) call fail("Invalid command 'abc' did not fail.")

  str = run('.', has_error)
  if (str /= '') call fail("Invalid command '.' has output.")
  if (.not. has_error) call fail("Invalid command '.' did not fail.")

  print *, achar(10)//achar(27)//'[92m All tests passed.'//achar(27)

contains

  subroutine fail(msg)
    character(*), intent(in) :: msg
    print *, achar(27)//'[31m'//'Test failed: '//msg//achar(27)//'[0m'
    stop 1
  end
end
