#! /bin/bash

#  Automatic Kernel Build Script
#  ver 1.8
#
#  Changelog:
#  v 0.1 - Original simple code.
#  v 0.2 - Added automatic download and unpack code.
#  v 0.3 - Added spacing between comands.
#  v 0.4 - Added configuration interface options.
#  v 0.5 - Fixed some bugs.
#  v 0.6 - Added bootloader configuration for grub and lilo.
#  v 0.7 - Added restart option at the end of the script.
#  v 0.8 - User can now specify the partition where you can find the bootloader.
#  v 0.9 - Fixed some bugs. Now the script makes initrd.
#  v 1.0 - The script first lets you know what kernel version you run on you system.
#  v 1.1 - Added colors to the script.
#  v 1.2 - Fixed some bugs and commented the code more carefully.
#  v 1.3 - Added a new line and commented the code more carefully.
#  v 1.4 - Fixed some bugs and added an option to clean the previous kernel code or not. 
#  v 1.5 - Added Download possibility and Make Dep for 2.4.x kernels.
#  v 1.6 - Fixed some bugs. Now the script is correctly adding the new kernel to grub.
#  v 1.7 - Commented out initrd lines.
#  v 1.8 - The script now automaticaly detects your bootloader and configures as necessary.
# 
#  Made by Ion Alin
#  alyn3d AT gmail DOT com

echo ""
echo ""
echo "\033[1;32m << Kernel Compilation Script >> \a\v\033[0m"
echo ""
echo ""
cd /usr/src

# Shows the kernel version that is currently installed on your system

echo ""
echo "\033[1;32m Your current kernel version is: \a\v\033[0m"
uname -r
echo ""

# Asks for the kernel verion you want to download, compile and install

echo "\033[1;32m What is the kernel version that you want to download and compile: \a\v\033[0m"
read VER

# Asks and if yes, cleans the previous kernel source code found in /usr/src

echo ""
echo "\033[1;32m Do you want to remove the previous kernel source code? (Y/N) \a\v\033[0m"
read REM
echo ""
case $REM in
  'Y')
    echo "\033[1;32m Removing the previous kernel source code... \a\v\033[0m";
    rm -rf linux-*;
     ;;
  'N')
    echo "\033[1;32m Leaving the previous kernel source code, initializing next stage... \a\v\033[0m";
     ;;
  'y')
    echo "\033[1;32m Removing the previous kernel source code... \a\v\033[0m";
    rm -rf linux-*;
     ;;
  'n')
    echo "\033[1;32m Leaving the previous kernel source code, initializing next stage... \a\v\033[0m";
     ;;
esac

echo ""

# Downloads and unpacks the kernel source code archive

echo ""
echo "Downloading the archive containing the kernel source..."
echo ""
case $VER in
  2.6.*)
    wget http://kernel.org/pub/linux/kernel/v2.6/linux-$VER.tar.bz2;
    MAKEDEP=0
     ;;
  2.6.*.*)
    wget http://kernel.org/pub/linux/kernel/v2.6/linux-$VER.tar.bz2;
    MAKEDEP=0;
     ;;
  2.4.*)
    wget http://kernel.org/pub/linux/kernel/v2.4/linux-$VER.tar.bz2;
    MAKEDEP=1;
     ;;
  2.4.*.*)
    wget http://kernel.org/pub/linux/kernel/v2.4/linux-$VER.tar.bz2;
    MAKEDEP=1
     ;;
esac
echo ""
echo "\033[1;32m Extracting archive... \a\v\033[0m \a\v\033[0m"
tar -jxf linux-$VER.tar.bz2
cd linux-$VER
echo ""


# Make dep for 2.4.x kernels if necessary

echo ""
case $MAKEDEP in
  1)
   echo "\033[1;32m Make Dep \a\v\033[0m";
   make dep;
    ;;
  0)
   echo "\033[1;32m Skipping Make Dep \a\v\033[0m";
    ;;
esac
echo ""

# Cleaning sources

echo ""
echo "\033[1;32m Cleaning... \a\v\033[0m"
make mrproper
echo ""

# Lets the user choose how to configure the linux kernel

echo ""
echo "\033[1;32m Configuring the kernel... \a\v\033[0m"
echo ""
echo "\033[1;32m Select configuration interface: \a\v\033[0m"
echo "\033[1;32m Options are: oldconfig menuconfig gconfig xconfig \a\v\033[0m"
echo "\033[1;32m oldconfig - loads your previous kernel configure file \a\v\033[0m"
echo "\033[1;32m menuconfig - loads a ncurses based interface \a\v\033[0m"
echo "\033[1;32m gconfig - loads a GTK based interface \a\v\033[0m"
echo "\033[1;32m xconfig - loads a QT based interface \a\v\033[0m"
echo ""
read OPT
case $OPT in
  'oldconfig')
    make oldconfig;
    ;;
  'menuconfig')
    make menuconfig;
    ;;
  'gconfig')
    make gconfig;
    ;;
  'xconfig')
    make xconfig;
    ;;
esac
echo ""

# Cleaning sources and Building the kernel

echo ""
echo "\033[1;32m Cleaning... \a\v\033[0m"
make clean
echo ""
echo ""
echo "\033[1;32m Building kernel image... \a\v\033[0m"
make bzImage
echo ""
echo ""
echo "\033[1;32m Building modules... \a\v\033[0m"
make modules
echo ""
echo ""
echo "\033[1;32m Installing modules... \a\v\033[0m"
make modules_install
echo ""
echo ""

# Copying and linking the kernel image

echo ""
echo "\033[1;32m Copying and linking the kernel image... \a\v\033[0m"
cp arch/i386/boot/bzImage /boot/bzImage-$VER
cp System.map /boot/System.map-$VER
ln -sf /boot/System.map-$VER /boot/System.map
cd /boot/
# mkinitrd -o /boot/initrd.img-$VER $VER
echo ""

# Installing the kernel image in GRUB or LILO

echo ""
echo "\033[1;32m Configuring your bootloader... \a\v\033[0m"
echo ""

# Detecting your bootloader

BOOT=$(find /sbin -name "lilo")

# Configuring your bootloader

echo ""
case $BOOT in
  '')
    echo "Detected GRUB as bootloader in your system";
    echo "What is your root partition?";
    echo "(hd0,1) or (hd0,0) or (hd0,2) or whatever do you have";
    read PART;
    ;;
  'lilo')
    echo "Detected LILO as bootloader in your system";
    echo "What is your root partition?";
    echo "/dev/hda2 or /dev/hda1 or /dev/hda3 or whatever do you have";
    read PART;
    ;;
esac    
echo ""

# Configure your bootloader to boot with the new kernel

case $BOOT in
  '')
    echo "\033[1;32m Configuring GRUB bootloader... \a\v\033[0m"
    echo "title Kernel ($VER)" >> /boot/grub/menu.lst;
    echo "root $PART" >> /boot/grub/menu.lst;
    echo "kernel /boot/bzImage-$VER ro root=LABEL=/" >> /boot/grub/menu.lst;
    # echo "initrd /boot/initrd.img-$VER" >> /boot/grub/menu.lst;
    echo "boot" >> /boot/grub/menu.lst;
    ;;
  'lilo')
    echo "\033[1;32m Configuring LILO bootloader... \a\v\033[0m"
    echo "image=/boot/bzImage-$VER" >> /etc/lilo.conf;
    echo "label=Kernel-$VER" >> /etc/lilo.conf;
    echo "root=$PART" >> /etc/lilo.conf;
    echo "read-only" >> /etc/lilo.conf;
    /sbin/lilo
    ;;
esac

# Finishing

echo ""
echo "\033[1;32m Your new kernel is now installed... \a\v\033[0m"
echo ""
echo ""
echo "\033[1;32m Do you want to restart the system ? \a\v\033[0m"
echo "\033[1;32m Options: Y / N \a\v\033[0m"
read RES
case $RES in
  'y')
    shutdown -r now;
    ;;
  'n')
    echo "\033[1;32m Good Bye! \a\v\033[0m";
    ;;
  'Y')
    shutdown -r now;
    ;;
  'N')
    echo "\033[1;32m Good Bye! \a\v\033[0m";
    ;;
esac
