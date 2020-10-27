#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/uaccess.h>

MODULE_LICENSE("GPL"); 

static int major_number;

static int device_open(struct inode *inode, struct file *filp)
{
    	printk(KERN_ALERT "Device opened.");
  	return 0;
}

static int device_release(struct inode *inode, struct file *filp)
{
    	printk(KERN_ALERT "Device closed.");
  	return 0;
}

static ssize_t device_read(struct file *filp, char *buffer, size_t length, loff_t *offset)
{
	char *msg = "Hello pwn.college!\n";
	return strlen(msg) - copy_to_user(buffer, msg, strlen(msg));
}

static ssize_t device_write(struct file *filp, const char *buf, size_t len, loff_t *off)
{
  	printk(KERN_ALERT "Sorry, this operation isn't supported.\n");
  	return -EINVAL;
}

static struct file_operations fops = {
  	.read = device_read,
  	.write = device_write,
  	.open = device_open,
  	.release = device_release
};

int init_module(void)
{
  	major_number = register_chrdev(0, "pwn-college-char", &fops);

  	if (major_number < 0) {
    		printk(KERN_ALERT "Registering char device failed with %d\n", major_number);
    		return major_number;
  	}

  	printk(KERN_INFO "I was assigned major number %d.\n", major_number);
  	printk(KERN_INFO "Create device with: 'mknod /dev/pwn-college-char c %d 0'.\n", major_number);
  	return 0;
}

void cleanup_module(void)
{
  	unregister_chrdev(major_number, "pwn-college-char");
}

