---
title: Live coding ONLY: Prodding & probing your binaries
subtitle: A Hands-On Debugging and Tracing Primer
author:
 - David Asabina
---

> Throughout this document, emoji's are used as a legend to mark sections. The
legend is as follows:
 - :boom: rant/personal opinion
 - :bulb: cool idea
 - :stuck_out_tongue_closed_eyes: funny, maybe
 - :muscle: demo

## Intro

In the spirit of "don't reinvent the wheel", this session aims to demonstrate
how well-suited existing tools are for debugging and tracing applications.
Many of the tools we think we need are often already there, albeit in a
user-intimidating[^1] form. We just need to learn how to use them and use them
well.

[^1]: These tools could easily be dismissed as user-unfriendly, but the reality is that these tools aren't too hard to use. They are intimidating from the onset, hence the term user-intimidating.

:boom: Software, with the access to better computing hardware, sometimes gets
passes for sloppiness. There is enough software out there that isn't really
efficient, eventhough efficiency should be a valuable metric in our software
engineering practice, if only to offload a few kilowatts that our planet would
otherwise pay the price for. Being efficient and wise in our resource
utilisation should be part of our effort to be sustainable, lean, clean and
green.

We drove the web on scripts for a long time. Leveraged the hell out of
interpreted languages, which were easier to get into for new developers???? but
languages like Go and Rust are in part responsible for rapidly changing the
landscape.

It's not just about languages though. It's about projects too. A project like
Cordano or Facebook's duckling, writen in Haskell, many tools from Hashicorp or
many of the tools in the Kubernetosphere, riding on top of the Golang train,
are making more of us familiar with the notion of our applications compiling to
binaries.

At some point, simply printf-ing your way through life will not suffice.

## Audience

This talk is targeted at developers who primarily debug-by-printf, and have
little to no experience with gdb, strace, perf and other debuggers or tracers.

## Structure

The talk starts by  demonstrating how a basic C application is compiled and
executed through the GDB.

After the initial demo, more complicated cases (stack overflows, memory leaks,
etc) are presented and walked through in order to provide the user a decent
basic understanding of the possibilities when using debuggers and tracers.

All demos will be executed in either a VM or container of which the entire
environment will be provided in a declarative manner (i.e.: Vagrantfile,
Dockerfile or the like).

### Adminstrative Note before we begin

 - [ ] Condense this section... Too much text. I don't have to write a complete
 script for the talk :wink:

I have provided a Dockerfile for everything covered in this talk. So anyone who
can wield a Docker sword to any degree of success should be able to follow
along.

If you don't have Docker installed, or don't know what it is...

Docker facilitates the usage of containers, sandboxes that provide one an
"isolated" machine that shares the kernel of the host. This is a bit leaner than
running a hypervisor and on top of that another kernel altogether which is what
happens when we were to use a VirtualBox for example.

I used Docker because it's pretty well-known and any issue you should run into
should be covered on StackOverflow. This process is far less painful that having
everyone install all the tools independently and figuring out that Jack can't
build something because of some incompatible depedencies that we can't upgrade
because it would break some other tools, or perhaps Lisa is using some obscure
Linux distro for which we would have to figure out how to get our deps first.
Nope. Let's keep it simple since I'm not a fan of imperative package management
strategies, where we incrementally add and upgrade packages on our machine with
multiple packages sharing the same libs or executables as dependencies, at all.
At some point there is always this one project that requires us to break our
setup but sandboxes (containers or vm's or Nix :snowflake: shells :metal:) allow
a user to manage environments in a less invasive manner. :wink:.  It's clean,
uninvasive and easily reproducible on other machines. :wink:

I use vi or emacs as editors in this talk. You may use "fancy" IDE's (read: use
more memory for no sensible reason and slow you down by having you
point-and-click your way through life), but in my experience vi/emacs are light,
fast and pack a hell of a punch if you know how to wield them.  Also... getting
used to these editors improve your dexterity when you've ssh-ed into a machine
with the hopes of getting shit done but doesn't have access to a graphical
environment.

> NOTE: Almost every box I've ever ssh-ed into provides some form of `vi`
editor. Hence my strong focus on vi. Don't read much into it. I think we should
all learn them both. Emacs in evil mode kicks ass :wink:

## Dockerfile

In order to create a Docker container, we specify a Dockerfile in which we
indicate which image we are using as a base through the `FROM`

## Workshop

The workshop is chopped into different sections. Each section covers another

### GDB

The GNU debugger is a versatile tool which allows us to prod and poke our
executables in a rather non-intrusive manner (i.e.: nonintrustive as in not
requiring us to litter our codebase with printf statements). In this demo we
will explore how to debug C/C++, Go and Rust applications.

### Dtrace

WIP

### Perf

WIP


# Links/References

[fatih]: https://www.twitter.com/@fatih vim-go author

[1]: https://sysdig.com/blog/sysdig-vs-dtrace-vs-strace-a-technical-discussion/
[tracers]: http://www.brendangregg.com/blog/2015-07-08/choosing-a-linux-tracer.html

# Issues

## Container not building at the moment because of 404.

```
Step 3/7 : RUN apt-get install -y gdb
 ---> Running in 86a55964cda6
Reading package lists...
Building dependency tree...
Reading state information...
The following extra packages will be installed:
  libc6-dbg libpython3.4
Suggested packages:
  gdb-doc gdbserver
Recommended packages:
  libc-dbg
The following NEW packages will be installed:
  gdb libc6-dbg libpython3.4
0 upgraded, 3 newly installed, 0 to remove and 2 not upgraded.
Need to get 6965 kB of archives.
After this operation, 33.8 MB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu/ trusty-updates/main libpython3.4 amd64 3.4.3-1ubuntu1~14.04.6 [1305 kB]
Get:2 http://archive.ubuntu.com/ubuntu/ trusty-updates/main gdb amd64 7.7.1-0ubuntu5~14.04.3 [2199 kB]
Err http://archive.ubuntu.com/ubuntu/ trusty-updates/main libc6-dbg amd64 2.19-0ubuntu6.13
  404  Not Found [IP: 91.189.88.162 80]
Err http://security.ubuntu.com/ubuntu/ trusty-security/main libc6-dbg amd64 2.19-0ubuntu6.13
  404  Not Found [IP: 91.189.88.152 80]
E: Failed to fetch http://security.ubuntu.com/ubuntu/pool/main/e/eglibc/libc6-dbg_2.19-0ubuntu6.13_amd64.deb  404  Not Found [IP: 91.189.88.152 80]

E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
Fetched 3503 kB in 14s (234 kB/s)
Removing intermediate container 86a55964cda6
The command '/bin/sh -c apt-get install -y gdb' returned a non-zero code: 100
make: *** [Makefile:8: image] Error 100
```

 - [ ] Provide pre-built container in Dockerhub
