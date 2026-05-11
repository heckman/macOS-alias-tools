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
and put the two universal binaries somewhere on your `PATH`.

Alternatively, build the binaries from source.
You will neet to have Command Line Tools (CLT) installed,
which can be installed with `xcode-select --install`.
Clone [the repository](https://github.com/heckman/macOS-alias-utils),
and change your current directory to its root.
From there, run `./build`.
This should produce the `readalias` and `mkalias` binaries
in a `./bin` directory.

## Features

At the moment, `readalias` simply prints the path to the original item
and has no options beyond `--help` and `--version`,
while `mkalias` can be given the `force` ( or `-f`) option
indicating existing files should be overwritten--by default it
is non-destructive.

Both respond appropriately to `--version` and `--help` options.
The help output includes descriptions their various exit codes.

### Future features

By default `mkalias` will fail
rather than overwrite and existing file.
The `force` (or `-f`) option will cause existing
files to be clobbbered, although a directory
will still not be overwritten.

I indend to offer a third behaviour, which,
when the specified name for the alias is taken,
generates a new name in the way the Finder does.
This might become the default behaviour
in which case we will need a new a command-line option
for the fail-on-existing file behaviour.

The renaming strategy is this: Use the same name as the original,
if avaialbe, otherwise append ` alias` to the name. If that
is still not unique, then append the smallest integer
greater than one, separated by a space, sufficient to
generate a unique name.

### Edge Cases

These utilites have only been nominally tested,
and most edge cases have not been explored:

- Broken Aliases
- Aliases to unmounted external/network volumes
- Creating and Alias to another Alias

## Props where due

Prior to writing these two utilites,
I was using _alisma_, by Howard Oakley,
which you can find on his site
[eclecticlight.co](https://eclecticlight.co/)
where he shares a great number of useful tools.

I found myself wrapping _alisma_ in shell functions to
provide interfaces that felt more natural to me,
so I decided to use the same system calls as _alisma_
to make these two separate utilities.
