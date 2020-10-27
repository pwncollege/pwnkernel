#!/bin/bash -ex

sudo apt-get install -y bison flex libelf-dev cpio build-essential

[ -e linux-4.19.87 ] || ( curl https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.19.87.tar.gz | tar xz )
cd linux-4.19.87
make defconfig
cat <<END >> .config
CONFIG_NET_9P=y
CONFIG_NET_9P_DEBUG=n
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_9P_FS_SECURITY=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BLK=y
CONFIG_VIRTIO_BLK_SCSI=y
CONFIG_VIRTIO_NET=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_DRM_VIRTIO_GPU=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_INPUT=y
CONFIG_CRYPTO_DEV_VIRTIO=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_PCI=y
CONFIG_PCI_HOST_GENERIC=y
END
make -j16 bzImage
cp arch/x86/boot/bzImage ..
cd ..

[ -e busybox-1.32.0 ] || ( curl https://busybox.net/downloads/busybox-1.32.0.tar.bz2 | tar xj )
cd busybox-1.32.0
make defconfig
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/g' .config
make -j16
make install
cd -

# filesystem
mkdir -p fs
cd fs
mkdir -p bin sbin etc proc sys usr/bin usr/sbin root home/ctf
echo 'root:x:0:0:root:/root:/bin/sh' >> etc/passwd
echo 'ctf:x:1000:1000:ctf:/home/ctf:/bin/sh' >> etc/passwd
cd -
cp -a busybox-1.32.0/_install/* fs
cp init fs
