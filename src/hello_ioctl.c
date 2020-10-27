#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/uaccess.h>

MODULE_LICENSE("GPL"); 

static int device_open(struct inode *, struct file *);
static int device_release(struct inode *, struct file *);
static ssize_t device_read(struct file *, char *, size_t, loff_t *);
static ssize_t device_write(struct file *, const char *, size_t, loff_t *);
static ssize_t device_ioctl(struct file *, const char *, unsigned long, unsigned long);

#define DEVICE_NAME "chardev"
#define BUF_LEN 80

static int major_number;

static struct file_operations fops = {
  	.read = device_read,
  	.write = device_write,
  	.compat_ioctl = device_ioctl,
  	.open = device_open,
  	.release = device_release
};

int init_module(void)
{
    	printk(KERN_ALERT "Hello pwn-college!");
  	major_number = register_chrdev(0, "pwn-college", &fops);

  	if (major_number < 0) {
    		printk(KERN_ALERT "Registering char device failed with %d\n", major_number);
    		return major_number;
  	}

  	printk(KERN_INFO "I was assigned major number %d.\n", major_number);
  	printk(KERN_INFO "Create device with: 'mknod /dev/pwn-college c %d 0'.\n", major_number);
  	return 0;
}

void cleanup_module(void)
{
  	unregister_chrdev(major_number, DEVICE_NAME);
    	printk(KERN_ALERT "Goodbye pwn-college!");
}

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
	char *msg = "Hello pwn-college!\n";
    	printk(KERN_ALERT "Device read: %p %ld %p", buffer, length, offset);
	return strlen(msg) - copy_to_user(buffer, msg, strlen(msg));
}

static ssize_t device_write(struct file *filp, const char *buf, size_t len, loff_t *off)
{
  	printk(KERN_ALERT "Sorry, this operation isn't supported.\n");
  	return -EINVAL;
}

static long device_ioctl(struct file *filp, const char *buf, unsigned long ioctl_num, unsigned long ioctl_param)
{
  	printk(KERN_ALERT "Got ioctl argument %ld!", ioctl_num);
  	return 0;
}
