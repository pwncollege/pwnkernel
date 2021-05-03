#!/bin/bash

export KERNEL_VERSION=5.11

debug_flag=''
dir='.'

usage() {
  echo "Usage: ./launch [arguments]" 
  echo ""
  echo "Arguments:"
  echo "  -D <path>     directory to mount in VM"
  echo "  -d            debug mode (add -S to QEMU)"
}

while getopts 'dD:' flag; do
  case "${flag}" in
    d) debug_flag='-S' ;;
    D) dir="${OPTARG}" ;;
    *) usage
       exit 1 ;;
  esac
done


#
# build root fs
#
pushd fs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs.cpio.gz
popd

#
# launch
#
/usr/bin/qemu-system-x86_64 \
	-kernel linux-$KERNEL_VERSION/arch/x86/boot/bzImage \
	-initrd $PWD/initramfs.cpio.gz \
	-fsdev local,security_model=passthrough,id=fsdev0,path=$dir \
	-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-nographic \
	-monitor none \
	-s $debug_flag \
	-append "console=ttyS0 nokaslr"
