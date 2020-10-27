obj-m = hello_dev_char.o hello_ioctl.o hello_log.o hello_proc_char.o make_root.o
KERNEL_VERSION=5.4

all: 
	echo $(OBJECTS)
	make -C ../linux-$(KERNEL_VERSION) M=$(PWD) modules

clean:
	make -C ../linux-$(KERNEL_VERSION) M=$(PWD) clean
