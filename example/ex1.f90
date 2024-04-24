program ex_1
  use run_f, only: run
  implicit none

  character(:), allocatable :: output

  output = run('whoami')
  print *, output
end
