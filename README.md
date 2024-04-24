# run-f

This simple Fortran library allows you to execute a command in the command line and save its result as a string without the need for a temporary file.

It was inspired by the work of [Jacob Williams](https://degenerateconic.com/fortran-c-interoperability.html) and uses `iso_c_binding` to call `popen`, `fgets` and `pclose` from the C standard library.

## Usage

First, import the `run_f` module into your Fortran code:

```fortran
use run_f, only: run
```

Then you can use the `run` function to execute a command and save its result as a string:

```fortran
character(len=:), allocatable :: output

output = run("whoami")
```

### Error Handling

### Print Command

### Ignore Errors

You can also use the `optional` arguments to add error handling or print the command to the console before executing it:

```fortran
character(:), allocatable :: output
character(*), parameter :: command = "whoami"
logical :: has_error

output = run(command, has_error, print_cmd=.true.)

if (has_error) then
  print *, "An error occurred while executing the command: ", command
  stop 1
end if
```

## Install

### fpm

Using [fpm](https://fpm.fortran-lang.org/en/index.html), you can simply add this package as a dependency to your `fpm.toml` file:

```toml
[dependencies]

[dependencies.run-f]
git = "https://github.com/minhqdao/run-f.git"
tag = "v0.1.0"
```

Then import the `run_f` module into your Fortran code:

```fortran
use run_f, only: run
```

Run `fpm build` to download the dependency.

## Tests

Run tests with:

```bash
fpm test
```

## Formatting

The CI will fail if the code is not formatted correctly. Please configure your editor to use [fprettify](https://pypi.org/project/fprettify/) and use an indentation width of 2 or run `fprettify -i 2 -r .` before committing.

## Contribute

Feel free to [create an issue](https://github.com/minhqdao/run-f/issues) in case you found a bug, have any questions or want to propose further improvements. Please stick to the existing coding style when opening a pull request.

## License

You can use, redistribute and/or modify the code under the terms of the [MIT License](https://github.com/minhqdao/run-f/blob/main/LICENSE).
