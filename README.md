# pwn.college helper environment for kernel development and exploitation

**NOTE: you don't need to interact with this repo in the course of interacting with pwn.college. The kernel challenges can be solved in the infrastructure; this is just here as a way to reproduce the infrastructure locally.**

Pre-requistite:

Building the kernel, busybox, and demo modules:

```
$ ./build.sh
```

Running the kernel:

```
$ ./launch.sh
```

All modules will be in `/`, ready to be `insmod`ed, and the host's home directory will be mounted as `/home/ctf` in the guest.
