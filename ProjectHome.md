# Automatic Kernel Build Script #

## News: ##

#### 18 Feb 07 - Automatic Kernel Build Script version 1.8 released ####
#### 25 Jan 07 - Automatic Kernel Build Script version 1.6 released ####
#### 23 Jan 07 - Automatic Kernel Build Script version 1.5 released ####
#### 15 Jan 07 - Automatic Kernel Build Script version 1.4 released ####

## Installation: ##

This is a script that helps the user to compile a linux kernel. It is written in BASH.

How to install the build kernel script:
```
1. Extract the contents of the archive
2. Login as root
3. Copy the .sh file into your /bin directory
4. Go to the /bin directory and run chmod +x kernelbuild.sh
```

Now the script is set up and you can run it from anywere.



## Changelog: ##

| v 0.1 - Original simple code. |
|:------------------------------|
| v 0.2 - Added automatic download and unpack code. |
| v 0.3 - Added spacing between comands. |
| v 0.4 - Added configuration interface options. |
| v 0.5 - Fixed some bugs. |
| v 0.6 - Added bootloader configuration for grub and lilo. |
| v 0.7 - Added restart option at the end of the script. |
| v 0.8 - User can now specify the partition where you can find the bootloader. |
| v 0.9 - Fixed some bugs. Now the script makes initrd. |
| v 1.0 - The script first lets you know what kernel version you run on you system. |
| v 1.1 - Added colors to the script. |
| v 1.2 - Fixed some bugs and commented the code more carefully. |
| v 1.3 - Added a new line and commented the code more carefully. |
| v 1.4 - Fixed some bugs and added an option to clean the previous kernel code or not. |
| v 1.5 - Added Download possibility and Make Dep for 2.4.x kernels. |
| v 1.6 - Fixed some bugs. Now the script is correctly adding the new kernel to grub. |
| v 1.7 - Commented out initrd lines. |
| v 1.8 - The script now automaticaly detects your bootloader and configures as necessary. |
