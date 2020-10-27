#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <linux/proc_fs.h>

MODULE_LICENSE("GPL"); 

static int device_open(struct inode *, struct file *);
static int device_release(struct inode *, struct file *);
static ssize_t device_read(struct file *, char *, size_t, loff_t *);
static ssize_t device_write(struct file *, const char *, size_t, loff_t *);

#define DEVICE_NAME "chardev"
#define BUF_LEN 80

static int open_num = 0;
struct proc_dir_entry *proc_entry = NULL;

static struct file_operations fops = {
  	.read = device_read,
  	.write = device_write,
  	.open = device_open,
  	.release = device_release
};

int init_module(void)
{
    	printk(KERN_ALERT "Hello pwn-college!");
  	proc_entry = proc_create("pwn-college", 0666, NULL, &fops);
  	return 0;
}

void cleanup_module(void)
{
    	if (proc_entry) proc_remove(proc_entry);                                                                                             
    	printk(KERN_ALERT "Goodbye pwn-college!");
}

static int device_open(struct inode *inode, struct file *filp)
{
    	if (open_num == 1) return -EINVAL;

    	printk(KERN_ALERT "Device opened.");
    	open_num++;
  	return 0;
}

static int device_release(struct inode *inode, struct file *filp)
{
    	printk(KERN_ALERT "Device closed.");
    	open_num--;
  	return 0;
}

static ssize_t device_read(struct file *filp, char *buffer, size_t length, loff_t *offset)
{
	char msg[128];
	snprintf(msg, 128, "Opened: %d!\n", open_num);
    	printk(KERN_ALERT "Device read: %p %ld %p", buffer, length, offset);
	return strlen(msg) - copy_to_user(buffer, msg, strlen(msg));
}

static ssize_t device_write(struct file *filp, const char *buf, size_t len, loff_t *off)
{
  	printk(KERN_ALERT "Sorry, this operation isn't supported.\n");
  	return -EINVAL;
}
