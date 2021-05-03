#!/bin/bash -e

export KERNEL_VERSION=5.11
export BUSYBOX_VERSION=1.32.0

#
# linux kernel
#

echo "[+] Downloading kernel..."
wget -q -c https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-$KERNEL_VERSION.tar.gz
[ -e linux-$KERNEL_VERSION ] || tar xzf linux-$KERNEL_VERSION.tar.gz

if ! test -f "linux-$KERNEL_VERSION/vmlinux"; then
  echo "[+] Building kernel..."
  make -C linux-$KERNEL_VERSION defconfig
  echo "CONFIG_NET_9P=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_NET_9P_DEBUG=n" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_9P_FS=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_9P_FS_POSIX_ACL=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_9P_FS_SECURITY=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_NET_9P_VIRTIO=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_VIRTIO_PCI=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_VIRTIO_BLK=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_VIRTIO_BLK_SCSI=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_VIRTIO_NET=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_VIRTIO_CONSOLE=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_HW_RANDOM_VIRTIO=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_DRM_VIRTIO_GPU=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_VIRTIO_PCI_LEGACY=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_VIRTIO_BALLOON=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_VIRTIO_INPUT=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_CRYPTO_DEV_VIRTIO=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_BALLOON_COMPACTION=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_PCI=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_PCI_HOST_GENERIC=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_GDB_SCRIPTS=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_DEBUG_INFO=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_DEBUG_INFO_REDUCED=n" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_DEBUG_INFO_SPLIT=n" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_DEBUG_FS=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_DEBUG_INFO_DWARF4=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_DEBUG_INFO_COMPRESSED=n" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_DEBUG_INFO_BTF=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_FRAME_POINTER=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_KASAN=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_KASAN_VMALLOC=y" >> linux-$KERNEL_VERSION/.config
  echo "CONFIG_TEST_KASAN_MODULE=n" >> linux-$KERNEL_VERSION/.config
  make -C linux-$KERNEL_VERSION -j16 bzImage
else
  echo "[+] Kernel already built"
fi

#
# Busybox
#
if ! test -f "busybox-$BUSYBOX_VERSION.tar.bz2"; then 
  echo "[+] Downloading busybox..."
  wget -q -c https://busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2
  [ -e busybox-$BUSYBOX_VERSION ] || tar xjf busybox-$BUSYBOX_VERSION.tar.bz2

  echo "[+] Building busybox..."
  make -C busybox-$BUSYBOX_VERSION defconfig
  sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/g' busybox-$BUSYBOX_VERSION/.config
  make -C busybox-$BUSYBOX_VERSION -j16
  make -C busybox-$BUSYBOX_VERSION install
fi

#
# filesystem
#
echo "[+] Building filesystem..."
cd fs
mkdir -p bin sbin etc proc sys usr/bin usr/sbin root home/ctf
cd ..
cp -a busybox-$BUSYBOX_VERSION/_install/* fs

echo "[+] Ready to pwn"
