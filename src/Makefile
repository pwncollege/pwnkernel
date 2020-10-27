obj-m = hello_log.o
obj-m += hello_dev_char.o
obj-m += hello_proc_char.o
obj-m += make_root.o
all:
	make -C ../linux-4.19.87 M=$(PWD) modules
clean:
	make -C ../linux-4.19.87 M=$(PWD) clean
