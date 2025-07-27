# Purpose
- This is a sample stack for working with Guile
- I'm working through some introductory material writing scheme.

## Goals 
- I didn't want to be shackled to GUIX if it can be avoided.
  * I'm not actually shackled to nix either, but I'm using it for this project because I'm on nix-os
  * having the dependencies installed on their own should work fine.
- I wanted to be able to run standalone executables for guile.
- However, it appears as though the GUILe builD tool (guild) only supports compiling scm scripts to 
    bytecode (frustratingly using a .go suffix for Guile Object file).
- The only way I've been able to find to run guile as a native executable is to create an accompanying c wrapper file,
    compiling this file, within which it utilizes the libguile which looks more or less like the [example](https://www.gnu.org/software/guile/manual/guile.html#A-Sample-Guile-Main-Program) from the manual, except that I'm using the (`scm_c_use_module`)[https://www.gnu.org/software/guile/manual/guile.html#index-scm_005fc_005fuse_005fmodule] function.
    * For namespace concerns I want to use modules for every file that will be designate as a compile TARGET except for tests
      - [ ] TODO: handle tests differently within the Makefile, so as not to use `scm_use_module` and just load the .scm file
        * FIX: this literally does not work at present.
    * These files are created at build time and targets are placed in the `Makefile` TARGETS variable
      - As part of the recipe, a c file is generated

## Dependencies
- Managed by nix, or by providing the dependencies specified by the nix flake 
    
## Building
### Directory Stucture
```
.
├── flake.lock
├── flake.nix
├── hello.scm
├── hello-test.scm
├── Makefile
└── README.md
```
- `flake.lock` is the lock file for the nix flake used to bring in the dependencies 
- `flake.nix` is flake that defines the build and dev shell dependencies
- `hello.scm` is a trivial example of a scheme file that defines a module
- `hello-test.scm` is a trivial example of a scheme test file testing the like-named scheme file.
- `Makefile` defines the recipes for building the different targets (some of which are tests)
  * this has gotten a little complicated (at least to me, so look at the comments in this file)
- `README.md` you are here

### Actually building
- compiling all the targets

```
>_: make all
```
  * this will create every `$target.c $target.go` file and a `$target` executable.
  * the resulting directory for building `hello` for example:
```
├── artifacts
│   ├── compiled
│   │   └── hello.go # this is the byte-compiled guile object file (bytecode)
│   ├── exe
│   │   └── hello    # this is the executable
│   └── hello.c      # this is the c wrapper
```
- [ ] TODO: make a `build-%` recipe, add `build-%` to .PHONY.
  * this will allow us to build individual targets
- the `hello` executable can then be run with
```
>_ make run-hello
```
- cleaning up
  * this will remove the generated `$target.c $target.go` files
```
>_: make clean
```
