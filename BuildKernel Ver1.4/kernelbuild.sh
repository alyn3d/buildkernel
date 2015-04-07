#! /bin/bash

#  Kernel compilation script
#  ver 1.4
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
wget http://kernel.org/pub/linux/kernel/v2.6/linux-$VER.tar.bz2
echo "\033[1;32m Extracting archive... \a\v\033[0m \a\v\033[0m"
tar -jxf linux-$VER.tar.bz2
cd linux-$VER
echo ""


# Cleaning sources

echo ""
echo "\033[1;32m Cleaning... \a\v\033[0m"
make mrproper
echo ""

# Lets the user choose how to congiure the linux kernel

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
mkinitrd -o /boot/initrd.img-$VER $VER
echo ""

# Installing the kernel image in GRUB or LILO according to the user specifications

echo ""
echo "\033[1;32m Configuring your bootloader... \a\v\033[0m"
echo ""
echo "\033[1;32m On what partition do you have your bootloader: \a\v\033[0m"
echo "\033[1;32m (hd0,1) ; (hd0,2) etc in GRUB \a\v\033[0m"
echo "\033[1;32m /dev/hda2 ; /dev/hda3 etc in LILO \a\v\033[0m" 
read PART
echo ""
echo "\033[1;32m What bootloader do you have? \a\v\033[0m"
echo "\033[1;32m Options are: grub lilo \a\v\033[0m"
echo ""
read BOOT
case $BOOT in
  'grub')
    echo "title Kernel ($VER)" >> /boot/grub/menu.lst;
    echo "root $PART" >> /boot/grub/menu.lst;
    echo "kernel /boot/bzImage-$VER ro root=LABEL=/" >> /boot/grub/menu.lst;
    echo "initrd /boot/initrd.img-$VER" >> /boot/grub/menu.lst;
    ;;
  'lilo')
    echo "image=/boot/bzImage-$VER" >> /etc/lilo.conf;
    echo "label=Kernel-$VER" >> /etc/lilo.conf;
    echo "root=$PART" >> /etc/lilo.conf;
    echo "read-only" >> /etc/lilo.conf;
    /sbin/lilo
    ;;
esac

# Finishing

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
