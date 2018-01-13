# Build

Built the example.c source file with the following command to produce a.out.

```
gcc -g -O0 example.c
```

Debug the application using the following command.

```
gdb a.out
```

## Issues

### Jumpy cursor due to optimization?

Somehow, after compiling the example.c file, I end up with an executable which
jumps in an unexpected manner. Upon `start` we get positioned at the beginning
of the main routine. The command `next` steps to the first printf, but a
subsequent `next` jumps over the remaining printf statements to the for-loop.

An attemp to `info locals` indicates that the index is `<optimized out>`. Which
is rather unexpected since the application was compiled with the `-O0` flags
which should result to an unoptimized binary. :confused:
[![asciicast](https://asciinema.org/a/aeoxZZcknnAC2hm6ucYIchHhX.png)](https://asciinema.org/a/aeoxZZcknnAC2hm6ucYIchHhX)
Note how the cursor jumps over the print statements.


