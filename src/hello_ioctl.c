#include <linux/uaccess.h>
#include <linux/proc_fs.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/cred.h>
#include <linux/fs.h>
#include <linux/ioctl.h>

#define PWN_GET _IO('p', 1)
#define PWN_SET _IO('p', 2)

MODULE_LICENSE("GPL"); 

char flag[128];
static int device_open(struct inode *inode, struct file *filp)
{
    	printk(KERN_ALERT "Device opened.\n");
  	return 0;
}

static int device_release(struct inode *inode, struct file *filp)
{
    	printk(KERN_ALERT "Device closed.\n");
  	return 0;
}

static ssize_t device_read(struct file *filp, char *buffer, size_t length, loff_t *offset)
{
	return -EINVAL;
}

static ssize_t device_write(struct file *filp, const char *buf, size_t len, loff_t *off)
{
  	return -EINVAL;
}

char message[16];
static long device_ioctl(struct file *filp, unsigned int ioctl_num, unsigned long ioctl_param)
{
        printk(KERN_ALERT "Got ioctl argument %#x!", ioctl_num);
        if (ioctl_num == PWN_GET && strcmp(message, "PASSWORD") == 0)
        	printk(KERN_ALERT "Write %ld bytes to userspace!\n", copy_to_user((char *)ioctl_param, flag, 128));
        else if (ioctl_num == PWN_SET)
        	printk(KERN_ALERT "Read %ld bytes from userspace!\n", copy_from_user(message, (char *)ioctl_param, 16));
        return 0;
}

static struct file_operations fops = {
  	.read = device_read,
  	.write = device_write,
  	.unlocked_ioctl = device_ioctl,
  	.open = device_open,
  	.release = device_release
};

struct proc_dir_entry *proc_entry = NULL;

int init_module(void)
{
	// read in flag file
	loff_t offset = 0;
	struct file *flag_fd;
	flag_fd = filp_open("/flag", O_RDONLY, 0);
	kernel_read(flag_fd, flag, 128, &offset);
	filp_close(flag_fd, NULL);

	printk(KERN_ALERT "ioctl address: %#lx\b", (unsigned long)device_ioctl);
	printk(KERN_ALERT "PWN_GET value: %#x\b", PWN_GET);
	printk(KERN_ALERT "PWN_SET value: %#x\b", PWN_SET);
    	proc_entry = proc_create("pwn-college-ioctl", 0666, NULL, &fops);
  	return 0;
}

void cleanup_module(void)
{
	if (proc_entry) proc_remove(proc_entry);
}

