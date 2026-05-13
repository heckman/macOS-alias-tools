# Alias Utils

Utilities for reading and writing MacOS alias files.

Includes two universal binaries:
`readalias` and `mkalias`,
for resolving and creating alias files.

Neither is very thouroughly tested.

The unversal binaries will run natively
on both Intel and Apple Silicon Macs.
I wrote these utilities
for my own needs using Tahoe 26.2,
but they are likely to work
on some earlier verions of macOS.

## Installation

Download the [latest release](https://github.com/heckman/macOS-alias-utils/releases/latest)
and put the two universal binaries in `bin` somewhere on your `PATH`.

The scripts in `scripts`can be installed the same way,
or, if using the `Zsh` shell, they can be used as autoloadable functions
by putting them somewhere on the `fpath`.
(This is how I use them.)

Alternatively, build the binaries from source.
You will neet to have Command Line Tools (CLT) installed,
which can be installed with `xcode-select --install`.
Clone [the repository](https://github.com/heckman/macOS-alias-utils),
and change your current directory to its root.
From there, run `./build`.
This should produce the `readalias` and `mkalias` binaries
in a `./bin` directory.

## Usage

Both binaries respond appropriately to `--version` and `--help` options.
The help output includes descriptions their various exit codes.

The help text is also easy to find in their source code.

### readalias

Prints the path to the original file of an alias file.
It takes no options, and has one required argument:

`readalias <alias-file>`

On error, nothing is printed to stdout,
an error message is printed to stderr,
and the exit status is non-zero.

### mkalias

Creates an alias file that points to the path of an original.
It takes two required positional arguments, and one optional
flag, which will cause `<alia-file>` to overwrite any existing file.
Be default, the command will fail if the file already exists.

`mkalias [-f|--force] [--] <path-of-original> <alias-file>`

Never writes to stdout.
On error, an message is printed to stderr,
and the exit status is non-zero.

## Scripts

These scripts make use of the `readalias` and `mkalias` binaries.
The funcionality provided by these scripts
may eventually be merged into the binaries,
or be made into new binaries themselves.
The format of these scripts is such that
the files can be used as autoloadable functions in Zsh
by simply placeing them in a directory on the `fpath`.
This is how I use them, which is why each script
is a single function called from its body, and why
the two helper functions have their own scripts.

### isalias

This wraps the `readalias` binary, and produces no output.
It produces a successful exit status (0) if the file provided
is an alias file, even if it is broken. It returns a non-zero
exit status otherwise.

### makealias

This forwards all arguments passed to it to the `mkalias` binary,
along with one additional argument: a name generated
using `namealias`, so `<alias-file>` can be unspecified,
in which case a suitable name will be generated.

### namealias

This is a helper used by `makealias`.
Given a path, this will print a name
suitable to be used for an alias file,
using the the same naming strategy used by the Finder.

### nextname

This is a helper used by `namealias`.
It prints a path that is guaranteed (at the moment) not to exist.
It takes the desired path as its only argument.
It prints the path if it does not exist, otherwise
it prints the path appended with a space and number, at least 2,
an only large enough to make the path unique.

## Issues

### Undetermined behaviour

These utilites have only been nominally tested,
and some edge cases have not been explored:

- Broken Aliases
- Aliases to unmounted external/network volumes

### Known edge cases

- Creating an Alias to another Alias file makes a new
  Alias pointing to the original of the other Alias.
  This is the expected behaviour.
- Arguments that are empty strings will be treated
  as `.`, which produces potentially confusing
  error messages such as "Error: directory exists:".

## Roadmap

- Incorporate scripts into binaries
- Generate an explicit error when arguments are empty
- Add formal testing

## Acknowledgements

Prior to writing these two utilites,
I was using _alisma_, by Howard Oakley,
which you can find on his site
[eclecticlight.co](https://eclecticlight.co/)
where he shares a great number of useful tools.

I found myself wrapping _alisma_ in shell functions to
provide interfaces that felt more natural to me,
so I decided to use the same system calls as _alisma_
to make these two separate utilities.
