# Simple BrainFuck interpreter written in NASM assembly
See [belamenso/bfc](https://github.com/belamenso/bfc) for my BrainFuck to x86 compiler.
## Dependencies
Works under 32- and 64-bit Intel machines running Linux.
```
nasm
gcc
gcc-multilib
```
## Usage
`make` to build.
```
bfc examples/hello_world.bf
```
## Interpretation vs compilation
On my machine (Ubuntu 16.04, Intel i7) compiled version of `hanoi.bf` executes in 6.24s while interpretation takes 25.15s.
