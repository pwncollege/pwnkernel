# pwn.college helper environment for kernel development and exploitation

Pre-requistite:

```
$ sudo apt install make
```

Building the kernel and demo modules:

```
$ make
```

Running the kernel:

```
$ ./launch.sh
```

All modules will be loaded at kernel startup, and the host's home directory will be mounted as /home/ctf in the guest.
