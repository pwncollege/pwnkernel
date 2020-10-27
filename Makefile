all: env modules

modules: env
	cd src; make
	cp src/*.ko fs/

modules-clean:
	cd src; make clean

env: apt-deps kernel busybox filesystem

env-clean:
	rm -rf fs bzImage linux-4.19.87 busybox-1.32.0

apt-deps:
	sudo apt-get install -y bison flex libelf-dev cpio build-essential qemu-system-x86

filesystem: busybox-1.32.0/_install
	cd fs && mkdir -p bin sbin etc proc sys usr/bin usr/sbin root home/ctf
	cp -a busybox-1.32.0/_install/* fs

busybox: busybox-1.32.0/_install

busybox-1.32.0/_install: busybox-1.32.0
	make -C busybox-1.32.0 defconfig
	sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/g' busybox-1.32.0/.config
	make -C busybox-1.32.0 -j16
	make -C busybox-1.32.0 install

kernel: bzImage

bzImage: linux-4.19.87
	make -C linux-4.19.87 defconfig
	echo "CONFIG_NET_9P=y" >> linux-4.19.87/.config
	echo "CONFIG_NET_9P_DEBUG=n" >> linux-4.19.87/.config
	echo "CONFIG_9P_FS=y" >> linux-4.19.87/.config
	echo "CONFIG_9P_FS_POSIX_ACL=y" >> linux-4.19.87/.config
	echo "CONFIG_9P_FS_SECURITY=y" >> linux-4.19.87/.config
	echo "CONFIG_NET_9P_VIRTIO=y" >> linux-4.19.87/.config
	echo "CONFIG_VIRTIO_PCI=y" >> linux-4.19.87/.config
	echo "CONFIG_VIRTIO_BLK=y" >> linux-4.19.87/.config
	echo "CONFIG_VIRTIO_BLK_SCSI=y" >> linux-4.19.87/.config
	echo "CONFIG_VIRTIO_NET=y" >> linux-4.19.87/.config
	echo "CONFIG_VIRTIO_CONSOLE=y" >> linux-4.19.87/.config
	echo "CONFIG_HW_RANDOM_VIRTIO=y" >> linux-4.19.87/.config
	echo "CONFIG_DRM_VIRTIO_GPU=y" >> linux-4.19.87/.config
	echo "CONFIG_VIRTIO_PCI_LEGACY=y" >> linux-4.19.87/.config
	echo "CONFIG_VIRTIO_BALLOON=y" >> linux-4.19.87/.config
	echo "CONFIG_VIRTIO_INPUT=y" >> linux-4.19.87/.config
	echo "CONFIG_CRYPTO_DEV_VIRTIO=y" >> linux-4.19.87/.config
	echo "CONFIG_BALLOON_COMPACTION=y" >> linux-4.19.87/.config
	echo "CONFIG_PCI=y" >> linux-4.19.87/.config
	echo "CONFIG_PCI_HOST_GENERIC=y" >> linux-4.19.87/.config
	make -C linux-4.19.87 -j16 bzImage
	cp linux-4.19.87/arch/x86/boot/bzImage .

# source downloads

linux-4.19.87:
	curl https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.19.87.tar.gz | tar xz
busybox-1.32.0:
	curl https://busybox.net/downloads/busybox-1.32.0.tar.bz2 | tar xj

