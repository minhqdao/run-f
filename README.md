# run-f

This Fortran library allows you to execute a command in the command line and receive the result as a string without the need for a temporary file.

It was inspired by [this article](https://degenerateconic.com/fortran-c-interoperability.html) and uses `iso_c_binding` to call `popen`, `fgets` and `pclose` from the C standard library.

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

Use the optional `has_error` argument to check if an error occurred while executing the command:

```fortran
character(len=:), allocatable :: output
logical :: has_error

output = run("whoami", has_error)
if (has_error) then
  print *, "Handle gracefully."; stop 1
end if
```

If you don't provide an error handler and something goes wrong while executing the command, the program will continue:

```fortran
character(:), allocatable :: output

output = run("abcxyz")
print *, "This line will be executed."
```

Be careful with different shell behavior and directives. For example, executing "." will not return an error on Ubuntu (bash) but it will do so on macOS (zsh).

### Print Command

You can also print the command before executing it by setting the optional `print_cmd` argument to `.true.`:

```fortran
character(len=:), allocatable :: output

output = run("whoami", print_cmd=.true.)
print *, output
```

Output:
```
Running command: 'whoami'
minh
```

## Install

### fpm

Using [fpm](https://fpm.fortran-lang.org), you can simply add this package as a dependency to your `fpm.toml` file:

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

Run `fpm build` to download and compile the dependency.

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
