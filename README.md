Compile source by running

```gcc -g INPUT_FILE -o OUTPUT_FILE```

where `INPUT_FILE` represents the source and `OUTPUT_FILE` corresponds to the
produced executable

# Basics

Build [hello.c](hello.c) using `gcc -g hello.c -o hello` and start gdb using

```gdb hello```

in order to get dropped into a debugger session.

Familiarize yourself with
 - starting the program (using `start`)
 - producing a listing of the application (using `list`)
 - stepping through the program (using `next` to recurse into subroutine calls
 or `step` to treat subroutine calls as a single source line) and
 - quiting (using `quit`)
in the normal mode and the TUI mode which is started through the binding `^x a`
(Depressing the control and the "x" key and then subsequently pressing the "a"
key).

 - `^x a`: toggle TUI mode, which corresponds to running
   - `tui enable` when not in TUI mode and
   - `tui disable` when in TUI mode
 - '^x 1'
 - '^x 2'
 - '^x l': redraw TUI

# Segmentation Fault


    start
    
    b main
    b _exit.c:32
    
    command 3
    run
    end
    
    command 2
    record
    continue
    end
    set pagination off

    run

`disas` disassemble

> NOTE: When debugging 01-basics/example.c and while stepping through the for-loop setting the index to a value greater thant the upper-boundary of the for-loop, somehow the for-loop ends up in a runaway state.

> NOTE: When debugging 01-basics/example.c and stepping through the code, I changed verbose to false in 01-basics/example.c and somehow gdb reloaded the source

> NOTE: When debugging 01-basics/example.c, I noticed that stepping through the code produces some jumpy behavior. For example, the first printf is respected but after entering next to cursor jumps to the for-loop.
