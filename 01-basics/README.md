# Build

Built the example.c source file with the following command to produce binary
a.out.

```
gcc -g -O0 example.c
```

> NOTE: that `-g` builds the binary with some extra information for debugging
purposes without this information the binary ends up a bit lighter and faster
but a bit debugger-unfriendly.

Debug the application using the following command.

```
gdb a.out
```

## Issues

### NixOS: Jumpy cursor due to optimization?

- https://github.com/NixOS/nixpkgs/issues/18995

Somehow, after compiling the example.c file, I end up with an executable which
jumps in an unexpected manner. Upon `start` we get positioned at the beginning
of the main routine. The command `next` steps to the first printf, but a
subsequent `next` jumps over the remaining printf statements to the for-loop.

An attemp to `info locals` indicates that the index is `<optimized out>`. Which
is rather unexpected since the application was compiled with the `-O0` flags
which should result to an unoptimized binary. :confused:
[![asciicast](https://asciinema.org/a/aeoxZZcknnAC2hm6ucYIchHhX.png)](https://asciinema.org/a/aeoxZZcknnAC2hm6ucYIchHhX)
Note how the cursor jumps over the print statements.

Apparently this issue can be traced to a screwed up build. The output of

```
readelf --debug-dump=decodedline a.out
```
looks like

```
Decoded dump of debug contents of section .debug_line:

CU: ../sysdeps/x86_64/start.S:
File name                            Line number    Starting address
start.S                                       63            0x4005f0

start.S                                       79            0x4005f2
start.S                                       85            0x4005f5
start.S                                       88            0x4005f6
start.S                                       90            0x4005f9
start.S                                       93            0x4005fd
start.S                                       97            0x4005fe
start.S                                      107            0x4005ff
start.S                                      108            0x400606
start.S                                      110            0x40060d
start.S                                      120            0x400614
start.S                                      122            0x40061a

CU: init.c:
File name                            Line number    Starting address

CU: ../sysdeps/x86_64/crti.S:
File name                            Line number    Starting address
crti.S                                        64            0x400548

crti.S                                        66            0x40054c
crti.S                                        67            0x400553
crti.S                                        68            0x400556
crti.S                                        69            0x400558
crti.S                                        80            0x400764


CU: ./example.c:
File name                            Line number    Starting address
example.c                                      6            0x400580

/nix/store/jxy9c9fbxqai3r66kx61jdwdpbzbhbl4-glibc-2.25-49-dev/include/bits/stdio2.h:
stdio2.h                                     104            0x400581

./example.c:[++]
example.c                                     15            0x40058f

/nix/store/jxy9c9fbxqai3r66kx61jdwdpbzbhbl4-glibc-2.25-49-dev/include/bits/stdio2.h:
stdio2.h                                     104            0x400591

./example.c:[++]
example.c                                     15            0x4005e0


/nix/store/jxy9c9fbxqai3r66kx61jdwdpbzbhbl4-glibc-2.25-49-dev/include/bits/stdio2.h:
stdio2.h                                     104            0x4005e3

./example.c:[++]
example.c                                     15            0x4005e8
example.c                                     22            0x4005ed

CU: ../sysdeps/x86_64/crtn.S:
File name                            Line number    Starting address
crtn.S                                        40            0x40055a

crtn.S                                        41            0x40055e
crtn.S                                        44            0x400768

crtn.S                                        45            0x40076c
```

I ran out in tears to the #gdb IRC channel on Freenode where simarka provided
the output of the debug-dump from his Ubuntu 16.04 setup.

```
Decoded dump of debug contents of section .debug_line:

CU: example.c:
File name                            Line number    Starting address
example.c                                      6            0x400526
example.c                                      7            0x40052e
example.c                                      8            0x40053d
example.c                                      9            0x40054c
example.c                                     10            0x40055b
example.c                                     12            0x40056a
example.c                                     13            0x400571
example.c                                     15            0x400575
example.c                                     17            0x40057e
example.c                                     19            0x400584
example.c                                     15            0x400598
example.c                                     15            0x40059c
example.c                                     22            0x4005a7
```

On NixOS the gcc debug has a lot of flags enabled by default for security
reasons in order to be able to throw errors at unsafe accesses, potential
overflows, stack violations and unsafe printfs, for example. One may
disable all hardening flags in NixOS by setting the `hardeningDisable`
attribute as follows

```hardeningDisable = [ "all" ]```

or by just disabling `fortify` hardening after which the objdump produces
something more in line with our expectations.

```
Decoded dump of debug contents of section .debug_line:

CU: ../sysdeps/x86_64/start.S:
File name                            Line number    Starting address
start.S                                       63            0x400560

start.S                                       79            0x400562
start.S                                       85            0x400565
start.S                                       88            0x400566
start.S                                       90            0x400569
start.S                                       93            0x40056d
start.S                                       97            0x40056e
start.S                                      107            0x40056f
start.S                                      108            0x400576
start.S                                      110            0x40057d
start.S                                      120            0x400584
start.S                                      122            0x40058a

CU: init.c:
File name                            Line number    Starting address

CU: ../sysdeps/x86_64/crti.S:
File name                            Line number    Starting address
crti.S                                        64            0x400520

crti.S                                        66            0x400524
crti.S                                        67            0x40052b
crti.S                                        68            0x40052e
crti.S                                        69            0x400530
crti.S                                        80            0x400754


CU: example.c:
File name                            Line number    Starting address
example.c                                      6            0x400656
example.c                                      7            0x40065e
example.c                                      8            0x40066d
example.c                                      9            0x40067c
example.c                                     10            0x40068b
example.c                                     12            0x40069a
example.c                                     13            0x4006a1
example.c                                     15            0x4006a5
example.c                                     17            0x4006ae
example.c                                     19            0x4006b4
example.c                                     15            0x4006c8
example.c                                     15            0x4006cc
example.c                                     22            0x4006d2

CU: ../sysdeps/x86_64/crtn.S:
File name                            Line number    Starting address
crtn.S                                        40            0x400532

crtn.S                                        41            0x400536
crtn.S                                        44            0x400758

crtn.S                                        45            0x40075c
```

`objdump -d -M intel --source --debugging --debugging-tags a.out`
