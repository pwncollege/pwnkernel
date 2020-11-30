#include <linux/uaccess.h>
#include <linux/proc_fs.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/cred.h>
#include <linux/fs.h>

#define PWN _IO('p', 1)

MODULE_LICENSE("GPL"); 

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
	return -EINVAL;
}

static ssize_t device_write(struct file *filp, const char *buf, size_t len, loff_t *off)
{
  	return -EINVAL;
}

static long device_ioctl(struct file *filp, unsigned int ioctl_num, unsigned long ioctl_param)
{
        printk(KERN_ALERT "Got ioctl argument %d!", ioctl_num);
        if (ioctl_num == PWN)
        {
        	if (ioctl_param == 0x13371337)
        	{
        		printk(KERN_ALERT "Granting root access!");
    			commit_creds(prepare_kernel_cred(NULL));
    		}
    		if (ioctl_param == 0x31337)
    		{
        		printk(KERN_ALERT "Escaping seccomp!");
        		printk(KERN_ALERT "FLAGS BEFORE: %lx", current->thread_info.flags);
    			current->thread_info.flags &= ~_TIF_SECCOMP;
        		printk(KERN_ALERT "FLAGS AFTER: %lx", current->thread_info.flags);
    		}
        }
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
    	proc_entry = proc_create("pwn-college-root", 0666, NULL, &fops);
  	return 0;
}

void cleanup_module(void)
{
	if (proc_entry) proc_remove(proc_entry);
}

