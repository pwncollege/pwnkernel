#include <linux/module.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL"); 
  
int init_module(void) 
{ 
    printk(KERN_INFO "Hello CSE466!\n");
    return 0;
} 
  
void cleanup_module(void) 
{ 
    printk(KERN_INFO "Goodbye class!\n");
} 
