all: env modules
clean: modules-clean env-clean

KERNEL_VERSION=5.4

modules: env
	cd src; make
	cp src/*.ko fs/

modules-clean:
	cd src; make clean
	rm -f fs/*.ko

env: apt-deps kernel busybox filesystem

env-clean:
	rm -rf bzImage linux-$(KERNEL_VERSION) busybox-1.32.0
	git clean -fxxd fs

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

kernel: linux-$(KERNEL_VERSION)/arch/x86/boot/bzImage

linux-$(KERNEL_VERSION)/arch/x86/boot/bzImage: linux-$(KERNEL_VERSION)
	make -C linux-$(KERNEL_VERSION) defconfig
	echo "CONFIG_NET_9P=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_NET_9P_DEBUG=n" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_9P_FS=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_9P_FS_POSIX_ACL=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_9P_FS_SECURITY=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_NET_9P_VIRTIO=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_VIRTIO_PCI=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_VIRTIO_BLK=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_VIRTIO_BLK_SCSI=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_VIRTIO_NET=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_VIRTIO_CONSOLE=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_HW_RANDOM_VIRTIO=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_DRM_VIRTIO_GPU=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_VIRTIO_PCI_LEGACY=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_VIRTIO_BALLOON=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_VIRTIO_INPUT=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_CRYPTO_DEV_VIRTIO=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_BALLOON_COMPACTION=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_PCI=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_PCI_HOST_GENERIC=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_GDB_SCRIPTS=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_DEBUG_INFO=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_DEBUG_INFO_REDUCED=n" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_DEBUG_INFO_SPLIT=n" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_DEBUG_FS=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_DEBUG_INFO_DWARF4=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_DEBUG_INFO_BTF=y" >> linux-$(KERNEL_VERSION)/.config
	echo "CONFIG_FRAME_POINTER=y" >> linux-$(KERNEL_VERSION)/.config
	make -C linux-$(KERNEL_VERSION) -j16 bzImage

# source downloads

linux-$(KERNEL_VERSION):
	wget -c https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-$(KERNEL_VERSION).tar.gz
	tar xzf linux-$(KERNEL_VERSION).tar.gz
busybox-1.32.0:
	curl https://busybox.net/downloads/busybox-1.32.0.tar.bz2 | tar xj

