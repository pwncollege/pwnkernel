# Linux kernel exploit easy setup

This is a simple fork from [pwnkernel](https://github.com/pwncollege/pwnkernel). I just adapted and removed a few things to make it specific to kernel exploit development.

## Dependencies

```sh
sudo apt-get -q update
sudo apt-get -q install -y bison flex libelf-dev cpio build-essential libssl-dev qemu-system-x86
```

## Kernel version

A `KERNEL_VERSION` variable is set up in `build.sh`.

## Building

Building the kernel and busybox:

```sh
./build.sh
```

### KASAN

By default, the kernel is built with `KASAN` to make bug triggering easier.
Comment the following line to build it normally:

```makefile
  echo "CONFIG_KASAN=y" >> linux-$KERNEL_VERSION/.config
```

Feel free to add other sanitizers :^)

## Running

Running the kernel:

```text
./launch.sh
Usage: ./launch [arguments]

Arguments:
  -D <path>     directory to mount in VM
  -d            debug mode (add -S in QEMU)
```

The host directory specified by the `-D` argument will be mounted inside `/home/ctf` guest directory.
