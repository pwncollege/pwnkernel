# pwn.college helper environment for kernel development and exploitation

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
