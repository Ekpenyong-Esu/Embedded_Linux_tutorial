# Embedded-Linux-Project

## This is what to installed in other to set the environment well

sudo apt-get install autoconf automake bison bzip2 cmake flex g++ gawk gcc gettext git gperf help2man libncurses5-dev libstdc++6 libtool libtool-bin make patch python3-dev rsync texinfo unzip wget xz-utils

the command you provided will install a set of commonly used development tools and libraries on a Debian/Ubuntu-based Linux system, which are often necessary for various development tasks, including embedded Linux development.

### Here's a breakdown of the packages being installed

autoconf: Tool for generating configure scripts.
automake: Tool for automatically generating Makefile.in files.
bison: Parser generator.
bzip2: File compression utility.
cmake: Cross-platform build system.
flex: Lexical analyzer generator.
g++: GNU C++ compiler.
gawk: GNU awk, a text processing language.
gcc: GNU C compiler.
gettext: Internationalization and localization library.
git: Version control system.
gperf: Perfect hash function generator.
help2man: Tool for generating man pages from program output.
libncurses5-dev: Development files for the ncurses terminal handling library.
libstdc++6: GNU Standard C++ Library.
libtool: Generic library support script.
libtool-bin: Binary implementing libtool.
make: GNU make utility.
patch: Utility to apply patches to files.
python3-dev: Header files and development tools for Python.
rsync: Fast file transfer program.
texinfo: Documentation system.
unzip: Utility for unpacking zip archives.
wget: Utility for downloading files from the web.
xz-utils: Utilities for managing .xz files.

## Building a toolchain using crosstool-NG

$ git clone https://github.com/crosstool-ng/crosstool-ng.git
$ cd crosstool-ng
$ git checkout crosstool-ng-1.26.0
$ ./bootstrap
$ ./configure --prefix=${PWD}
$ make
$ make install

The --prefix=${PWD} option means that the program will be installed into the current
directory, which avoids the need for root permissions, as would be required if you were to
install it in the default location /usr/local/share.

$ bin/ct-ng list-samples  ### This list all the rchitecture we have in croos-NG

$ bin/ct-ng show-arm-cortex_a8-linux-gnueabi ### checking the content of the architexture

$ bin/ct-ng arm-cortex_a8-linux-gnueabi      ### Here we choose the architecture that is compatible with beaglebone black

$ bin/ct-ng menuconfig ### This open up menu for configuration and allow you to select what you want to with the tool chain

$ bin/ct-ng build  ### This build the tool chain

ls ~/x-tools/arm-cortex_a8-linux-gnueabihf.  ### This list the content in the arm-cortex_a8-linux-gnueabihf folder.

$ bin/ct-ng distclean   ### To build another architecture we need to clean the the previous build

## Building a toolchain for QEMU

$ bin/ct-ng distclean    ### clean the directory
$ bin/ct-ng arm-unknown-linux-gnueabi     ### The architecture to use for QEMU tool chain and we are selectig it

$ bin/ct-ng menuconfig ### This open up the menu config for configuration

## Bootloader

The bootloader we are using is the uboot

The first thing to do is to cline it using the git clone

$ git clone git://git.denx.de/u-boot.git
$ cd u-boot
$ git checkout v2024.04

## Building Uboot

$ source ../EMBEDDED-LINUX-PROJECT/Chapter02/set-path-arm-cortex_a8-linux-gnueabihf

$ make am335x_evm_defconfig

$ make

## How to port a uboot to a new board that has the same SoC with beagle bone black

If the Nova board shares the same System on Chip (SoC) with the BeagleBone Black, you can start by using the BeagleBone Black's board configuration as a template for creating the configuration for the Nova board. Here's how you can proceed:

* Locate BeagleBone Black Configuration: Find the existing BeagleBone Black board configuration in the U-Boot source code. This configuration is typically located in a directory like board/ti/beaglebone.
* Copy Configuration Files: Copy the entire BeagleBone Black board directory to a new directory named after your Nova board. For example, if your Nova board is called "nova", you might name the directory board/ti/nova.
* Update Configuration Files: Inside the new board directory (board/ti/nova), update the configuration files to reflect the specific hardware configuration of the Nova board. This includes details such as memory size, GPIO pin mappings, and any other hardware peripherals that differ from the BeagleBone Black.
* Adjust Makefile: Modify the Makefile in the new board directory to reflect the name of your Nova board and any other relevant changes. This file specifies how the board-specific files are compiled.
* Make Necessary Changes: Review the configuration files and make any necessary changes to accommodate the differences between the BeagleBone Black and the Nova board. This may involve modifying pin configurations, enabling or disabling peripherals, and adjusting clock settings.
* Test Compile: Attempt to compile U-Boot with the new board configuration. Ensure that there are no compilation errors and that the resulting U-Boot image is generated successfully.
* Flash and Test: Flash the compiled U-Boot image onto the Nova board and test its functionality. Verify that U-Boot boots correctly and initializes the hardware components of the Nova board as expected.
* Debug and Iterate: If you encounter any issues during testing, debug the problems and iterate on your modifications as needed. This may involve reviewing log outputs, tracing code execution, and making further adjustments to the board configuration.
* Documentation: Document the changes made to the board configuration files and any additional steps taken during the process. This documentation will be helpful for reference and for sharing with others who may be working on similar projects.
By following these steps, you can create a new board configuration for the Nova board based on the existing configuration for the BeagleBone Black, adapting it to the specific hardware requirements of the Nova board.

## Building the linux kernel

* 1 Clone the Repository (if you haven't already)
Run the command you provided:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

* 2 Check the Version:
After cloning, navigate to the cloned directory:

cd linux-stable

Then, use the following command to see the current version (tag):

git tag -l | sort -V | tail -1

## How to build a beagle bone linux kernel

first we need to set up the environment base on  the kernel we have want to build

PATH=${HOME}/x-tools/arm-cortex_a8-linux-gnueabihf/bin/:$PATH
export CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf-
export ARCH=arm

Navigate to the kernel source directory:

cd linux-stable
This changes the current directory to linux-stable, which is assumed to be the directory containing the Linux kernel source code.

Clean the kernel build environment:

make ARCH=arm CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf- mrproper
The mrproper target cleans the kernel source tree, removing all generated files and ensuring a clean state. The ARCH=arm specifies that we are targeting the ARM architecture, and CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf- specifies the prefix for the cross-compilation toolchain.

Set up the default configuration for ARM multi-platforms:

make ARCH=arm multi_v7_defconfig
This command sets up the default configuration for ARM architecture targeting multiple ARMv7 platforms (which includes Cortex-A8). The multi_v7_defconfig is a predefined configuration file in the kernel source tree.

Compile the kernel image:

make -j4 ARCH=arm CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf- zImage
This command compiles the kernel image (zImage). The -j4 option tells make to use 4 parallel jobs, which can speed up the compilation process.

Compile the kernel modules:

make -j4 ARCH=arm CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf- modules
This command compiles the kernel modules. Kernel modules are pieces of code that can be loaded and unloaded into the kernel at runtime, providing additional functionality without requiring a kernel reboot.

Compile the device tree blobs (DTBs):

make ARCH=arm CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf- dtbs
This command compiles the device tree blobs. Device tree blobs describe the hardware layout to the kernel, which is especially important for embedded systems like those running on ARM architectures.

Note:
There is a small typo in the command for compiling the device tree blobs. It should be:

make ARCH=arm CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf- dtbs
In your provided commands, the line was broken incorrectly:

make ARCH=arm CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf- dtbs

This sequence of commands will compile a Linux kernel tailored for ARM Cortex-A8 processors, including the main kernel image, any additional kernel modules, and the device tree blobs required for proper hardware initialization.

## To build linux kernel for Qemu

first set the environment by using.

PATH=${HOME}/x-tools/arm-unknown-linux-gnueabi/bin/:$PATH
export CROSS_COMPILE=arm-unknown-linux-gnueabi-
export ARCH=arm

Navigate to the kernel source directory:

cd ~/linux-stable
Clean the build environment (optional, but recommended to ensure a clean state):

make ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi- mrproper
Create a default configuration file:

make ARCH=arm multi_v7_defconfig
This command sets up a default configuration for ARM platforms. The multi_v7_defconfig is a predefined configuration file suitable for various ARMv7 platforms.

Compile the kernel image:

make -j4 ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi- zImage
Now that the .config file is in place, this command will proceed to compile the kernel image.

Alternatively, if you want to customize the kernel configuration, you can use one of the following commands after step 2:

Text-based configuration menu:

make ARCH=arm menuconfig
Graphical configuration menu (requires libncurses5-dev or libncurses-dev):

make ARCH=arm xconfig
These commands will guide you through configuring the kernel options, and upon saving the configuration, a .config file will be created.

Here is the full corrected sequence of commands:

cd ~/linux-stable
make ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi- mrproper
make ARCH=arm versatile_defconfig
make -j4 ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi- zImage
make -j4 ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi- modules
make ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi- zImage dtbs
This ensures that the .config file is generated correctly, allowing you to compile the kernel image, modules, and device tree blobs without errors.

* How to boot the QEMU KERNEL
* Instal the qemu in your linux machine by using
  
```bash
sudo apt install qemu-system-arm
```

```bash
QEMU_AUDIO_DRV=none qemu-system-arm -m 256M -nographic -M versatilepb -kernel zImage -append "console=ttyAMA0,115200" -dtb versatile-pb.dtb

or 

QEMU_AUDIO_DRV=none qemu-system-arm -m 256M -nographic -M versatilepb -kernel arch/arm/boot/zImage -append "console=ttyAMA0,115200" -dtb arch/arm/boot/dts/arm/versatile-pb.dtb
## Buiding kernel for raspberry pi 3

* Download the Toolchain:

cd ~
(old and not working path)
wget <https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz>

* wget <https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz>

* Extract the Toolchain:

tar xf gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz

* Rename the Toolchain Directory (Optional):

mv gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu gcc-arm-aarch64-none-linux-gnu

* clone raspberry firmware
  
```bash
git clone <https://github.com/raspberrypi/firmware.git>
```

and remove this files extension

$ rm firmware/boot/kernel*
$ rm firmware/boot/*.dtb
$ rm firmware/boot/overlays/*.dtbo

* Clone the Raspberry Pi Linux kernel repository:

```bash
git clone --depth=1 --branch rpi-5.15.y <https://github.com/raspberrypi/linux.git>
```

* Configure the kernel for the Raspberry Pi 4:
PATH=~/gcc-arm-aarch64-none-linux-gnu/bin/:$PATH

* Build the 64-bit kernel, modules, and Device Tree blobs:

$ cd linux
$ make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- \
bcm2711_defconfig
$ make -j4 ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-

* After the image finish builing

$ cp arch/arm64/boot/Image ../firmware/boot/kernel8.img
$ cp arch/arm64/boot/dts/overlays/*.dtbo ../firmware/boot/overlays/
$ cp arch/arm64/boot/dts/broadcom/*.dtb ../firmware/boot/
$ cat << EOF > ../firmware/boot/config.txt
enable_uart=1
arm_64bit=1
EOF
$ cat << EOF > ../firmware/boot/cmdline.txt
console=serial0,115200 console=tty1 root=/dev/mmcblk0p2
rootwait
EOF

* What this line of code does is

Copy Kernel and Device Tree Files

$ cp arch/arm64/boot/Image ../firmware/boot/kernel8.img

Copies the compiled kernel image from the build directory (arch/arm64/boot/Image) to the ../firmware/boot/ directory, renaming it to kernel8.img.
kernel8.img is the filename expected by the Raspberry Pi firmware for a 64-bit ARM kernel.

$ cp arch/arm64/boot/dts/overlays/*.dtbo ..//firmwareboot/overlays/
Copies all Device Tree Blob Overlay files (*.dtbo) from the build directory to the ../firmware/boot/overlays/ directory.
Device Tree Blob Overlays are used to describe hardware configurations and can be applied dynamically to modify the base Device Tree.

$ cp arch/arm64/boot/dts/broadcom/*.dtb ../firmware/boot/
Copies all Device Tree Blob files (*.dtb) from the build directory to the ../boot/ directory.
Device Tree Blobs describe the hardware layout to the kernel.

Create config.txt

$ cat << EOF > ../firmware/boot/config.txt
enable_uart=1
arm_64bit=1
EOF

Creates or overwrites the config.txt file in the ../firmware/boot/ directory with the following contents:

enable_uart=1
arm_64bit=1
enable_uart=1 enables the UART (serial console).
arm_64bit=1 enables 64-bit mode on the Raspberry Pi.
Create cmdline.txt

$ cat << EOF > ../firmware/boot/cmdline.txt
console=serial0,115200 console=tty1 root=/dev/mmcblk0p2
rootwait
EOF

Creates or overwrites the cmdline.txt file in the ../firmware/boot/ directory with the following contents:

console=serial0,115200 console=tty1 root=/dev/mmcblk0p2 rootwait
console=serial0,115200: Directs kernel messages to the serial console (serial0) at 115200 baud rate.
console=tty1: Directs kernel messages to the first virtual terminal (tty1).
root=/dev/mmcblk0p2: Specifies the root filesystem location, which is the second partition on the first MMC device (usually the SD card).
rootwait: Tells the kernel to wait until the root filesystem is available before proceeding.
Summary
This sequence of commands performs the following tasks:

Copy the custom-built kernel and device tree files to the appropriate locations in the boot partition (../firmware/boot/).
Create a config.txt file to enable UART and set the system to 64-bit mode.
Create a cmdline.txt file to specify kernel boot parameters, including console output settings and the root filesystem location.
These steps prepare the Raspberry Pi to boot with a custom 64-bit kernel, providing necessary configurations and kernel parameters for proper operation.

* How to boot the kernel in the raspberry pi

|* Make sure that you only copy the content of /firmware/boot/ and not the folder

```bash
cp firmware/boot/*  /media/mahonri/boot
```

* Finally unmount

  ```bash
  sudo umount /media/mahonri/boot
  ```

## Booting the beaglebone image

after building the image

* copy the image and the dtb files to the booting partion of the sd card

 ```bash
 sudo cp arch/arm/boot/dts/ti/omap/am335x-boneblack.dtb /media/mahonri/boot
 ```

  ```bash
  sudo cp arch/arm/boot/zImage /media/mahonri/boot
  ```

* set up the environment
* This series of commands is used in the U-Boot bootloader environment to configure and boot an embedded Linux system, specifically for a device like the BeagleBone Black.
* setenv bootargs ...: This command sets the environment variable bootargs which contains kernel parameters.
* console=ttyO0,115200n8: This specifies the serial console to be used by the kernel for debug messages and login, where ttyO0 refers to the serial port, 115200 is the baud rate, and n8 means 8 data bits, no parity.
* root=/dev/mmcblk0p2: This indicates that the root filesystem is located on the second partition of the MMC/SD card.
* rw: This option tells the kernel to mount the root filesystem in read-write mode.
* rootwait: This tells the kernel to wait (indefinitely) for the root device to become available, useful for slow devices.
* fatload mmc 0:1 0x80200000 zImage: This command loads the Linux kernel image (zImage) from the first partition (0:1) of the MMC/SD card into memory at address 0x80200000.
* fatload mmc 0:1 0x80F00000 am335x-boneblack.dtb: This command loads the device tree blob (am335x-boneblack.dtb) from the first partition (0:1) of the MMC/SD card into memory at address 0x80F00000. The device tree provides the kernel with information about the hardware.
* bootz 0x80200000 - 0x80F00000: This command boots the Linux kernel from the address 0x80200000. The - indicates that there is no initial RAM disk (initrd), and 0x80F00000 is the address of the device tree blob.

```bash
setenv bootargs console=ttyO0,115200n8 root=/dev/mmcblk0p2 rw rootwait
fatload mmc 0:1 0x80200000 zImage
fatload mmc 0:1 0x80F00000 am335x-boneblack.dtb
bootz 0x80200000 - 0x80F00000
```

* setenv bootargs: Sets kernel parameters, defining the console and root filesystem.
* fatload mmc 0:1 0x80200000 zImage: Loads the kernel image into memory.
* fatload mmc 0:1 0x80F00000 am335x-boneblack.dtb: Loads the device tree blob into memory.
* bootz 0x80200000 - 0x80F00000: Boots the kernel with the loaded kernel image and device tree blob.

## ROOTFILESYSTEMS

* First create some directory for the host pc

```bash
mkdir ~/rootfs
cd ~/rootfs
mkdir bin dev etc home lib proc sbin sys tmp usr var
mkdir usr/bin usr/lib usr/sbin
mkdir -p var/log
```

where the

* /bin: Programs essential for all users
* /dev: Device nodes and other special files
* /etc: System configuration files
* /lib: Essential shared libraries, for example, those that make up the C library
* /proc: Information about processes represented as virtual files
* /sbin: Programs essential to the system administrator
* /sys: Information about devices and their drivers represented as virtual files
* /tmp: A place to put temporary or volatile files
* /usr: Additional programs, libraries, and system administrator utilities, in the
* /usr/bin, /usr/lib, and /usr/sbin directories, respectively
* /var: A hierarchy of files and directories that may be modified at runtime, for
example, log messages, some of which must be retained after boot

* You can use the tree linux command to check the tree layout of the directory you have created

```bash
tree -d 
```

* To change the USER ID called UID of the folders to super ID we

```bash
to set SUID on /bin/ping in your staging root directory, you would prepend
4 to a mode of 755 like so

cd ~/rootfs
ls -l bin/ping

sudo chmod 4755 bin/ping
ls -l bin/ping
```

* File ownership
  
* we give the folder root ownership by
  
```bash
sudo chown -R root:root *
cd ~/rootfs
```

* Building busy box

```bash
git clone git://busybox.net/busybox.git
cd busybox
git checkout 1_36_1

make distclean
make defconfig
```

* At this point, you probably want to run make menuconfig to fine-tune the
configuration. For example, you almost certainly want to set the install path in Busybox
Settings | Installation Options (CONFIG_PREFIX) to point to the staging directory.
Then, you can cross-compile in the usual way. If your intended target is the BeagleBone
Black, use this command:

```bash
make ARCH=arm CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf-
```

If your intended target is the QEMU emulation of a Versatile PB, use this command:

```bash
make ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi-
```

* In either case, the result is the executable busybox. For a default configuration build like
this, the size is about 900 KiB. If this is too big for you, you can slim it down by changing
the configuration to leave out the utilities you don't need.
To install BusyBox into the staging area, use the following command:

```bash
make ARCH=arm CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf- install
```

or for qmu

```bash
make ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi- install
```

* Create device nodes: (Optional) If you're building a system that needs device nodes, you can create a few essential ones manually:

```bash
cd ~/rootfs
sudo mknod -m 666 dev/null c 1 3
sudo mknod -m 600 dev/console c 5 1
ls -l dev
total 0
crw------- 1 root root 5, 1 Mar 22 20:01 console
crw-rw-rw- 1 root root 1, 3 Mar 22 20:01 null
```

* Create an Init Script

```bash
mount -t proc proc /proc
mount -t sysfs sysfs /sys
```

* Transfering the root filesystem to the target and creating the rootfilesystem
  We first create the uRamdisk by using the uboot

```bash
cd rootfs
find . | cpio -H newc -ov --owner root:root > ../initramfs.cpio
cd ..
gzip initramfs.cpio
mkimage -A arm -O linux -T ramdisk -C gzip -d initramfs.cpio.gz uRamdisk
```

* copy the uRamdisk file to your SD card's boot partition along with the kernel image (zImage) and device tree blob (am335x-boneblack.dtb)

```bash
sudo cp -r /home/mahonri/uRamdisk /media/mahonri/boot
```

* Boot your BeagleBone Black using the SD card and enter the following commands at the U-Boot prompt:

```bash
fatload mmc 0:1 0x80200000 zImage
fatload mmc 0:1 0x80f00000 am335x-boneblack.dtb
fatload mmc 0:1 0x81000000 uRamdisk
setenv bootargs console=ttyO0,115200 rdinit=/bin/sh
bootz 0x80200000 0x81000000 0x80f00000
```

* Creating for Qemu

```bash
mkimage -A arm -O linux -T ramdisk -C gzip -d initramfs.cpio.gz uRamdisk
```

* Run the Qemu with this comand

```bash
QEMU_AUDIO_DRV=none qemu-system-arm -m 256M -nographic -M versatilepb -kernel /home/mahonri/linux-stable/arch/arm/boot/zImage -append "console=ttyAMA0,115200 rdinit=/bin/sh" -dtb /home/mahonri/linux-stable/arch/arm/boot/dts/arm/versatile-pb.dtb -initrd /home/mahonri/initramfs.cpio.gz  
```

## AUTOMATING THE BUILD PROCESS USING BUILDROOT OR YOCTO

* Using buildroot
  
As usual, you can install Buildroot either by cloning the repository or downloading an
archive. Here is an example of obtaining version 2020.02.9, which was the latest stable
version at the time of writing:

```bash
git clone git://git.buildroot.net/buildroot -b 2024.02.6
cd buildroot
```

You can configure Buildroot from scratch directly using make menuconfig
(xconfig or gconfig), or you can choose one of the 100+ configurations for various
development boards and the QEMU emulator, which you can find stored in the configs/
directory. Typing make list-defconfigs lists all the default configurations.
Let's begin by building a default configuration that you can run on the Arm
QEMU emulator:

```bash
cd buildroot
make qemu_arm_versatile_defconfig
make
```

Important note
You do not tell make how many parallel jobs to run with a -j option:
Buildroot will make optimum use of your CPUs all by itself. If you want to
limit the number of jobs, you can run make menuconfig and look under
the Build options.

The build will take half an hour to an hour or more, depending on the capabilities of your
host system and the speed of your link to the internet. It will download approximately 220
MiB of code and will consume about 3.5 GiB of disk space. When it is complete, you will
find that two new directories have been created:
• dl/: This contains archives of the upstream projects that Buildroot has built.
• output/: This contains all the intermediate and final compiled resources.
You will see the following in output/:
• build/: Here, you will find the build directory for each component.
• host/: This contains various tools required by Buildroot that run on the host,
including the executables of the toolchain (in output/host/usr/bin).
• images/: This is the most important of all since it contains the results of the build.
Depending on what you selected when configuring, you will find a bootloader, a
kernel, and one or more root filesystem images.
• staging/: This is a symbolic link to sysroot of the toolchain. The name of the
link is a little confusing because it does not point to a staging area, as I defined it in
Chapter 5, Building a Root Filesystem.
• target/: This is the staging area for the root directory. Note that you cannot use
it as a root filesystem as it stands because the file ownership and the permissions
are not set correctly. Buildroot uses a device table, as described in the previous
chapter, to set ownership and permissions when the filesystem image is created in
the image/ directory.

## RUNNING THE QEMU

Some of the sample configurations have a corresponding entry in the board/ directory,
which contains custom configuration files and information about installing the results on
the target. In the case of the system you have just built, the relevant file is board/qemu/
arm-versatile/readme.txt, which tells you how to start QEMU with this target.
Assuming that you have already installed qemu-system-arm, as described in Chapter 1,
Starting Out, you can run it using this command:

```bash
qemu-system-arm -M versatilepb -kernel output/images/zImage -dtb output/images/versatile-pb.dtb -drive file=output/images/rootfs.ext2,if=scsi,format=raw -append "rootwait root=/dev/sda console=ttyAMA0,115200" -serial stdio -net nic,model=rtl8139 -net user # qemu_arm_versatile_defconfig
```

The login details is: Log in as root, with no password.

## Targeting real hardware like the raspberry pi

The steps for configuring and building a bootable image for the Raspberry Pi 4 are almost
the same as for Arm QEMU:

```bash
cd buildroot
make clean
make raspberrypi4_64_defconfig
make
```

When the build finishes, the image is written to a file named output/images/
sdcard.img.
After then use etcher in flashing the image

## Creating a custom BSP

Let's begin by creating a directory to store changes for the Nova board:

```bash
mkdir -p board/melp/nova
```

Next, clean the artifacts from any previous build, which you should always do when changing configurations:

```bash
make clean
```

Now, select the configuration for the BeagleBone, which we are going to use as the basis of the Nova configuration:

```bash
make beaglebone_defconfig
```

The make beaglebone_defconfig command configures Buildroot to build an image
targeting the BeagleBone Black. This configuration is a good starting point, but we still need to customize it for our Nova board. Let's start by selecting the custom U-Boot patch we created for Nova.

## Installing the Yocto Project

To get a copy of the Yocto Project, clone the repository, choosing the code name as the branch, which is dunfell in this case:

```bash
git clone -b scarthgap git://git.yoctoproject.org/poky.git

```

### Configuring

As with Buildroot, let's begin with a build for the QEMU Arm emulator. Begin by
sourcing a script to set up the environment:

```bash
source poky/oe-init-build-env
```

This creates a working directory for you named build/ and makes it the current
directory. All of the configuration, as well as any intermediate and target image files, will be put in this directory. You must source this script each time you want to work on this project.

You can choose a different working directory by adding it as a parameter to
oe-init-build-env; for example:

```bash
source poky/oe-init-build-env build-qemuarm
```

This will put you into the build-qemuarm/ directory. This way, you can have several build directories, each for a different project: you choose which one you want to work with through the parameter that's passed to oe-init-build-env.

For now, we just need to set the MACHINE variable in conf/local.conf to qemuarm
by removing the comment character (#) at the start of this line:

### Building

To actually perform the build, you need to run BitBake, telling it which root filesystem image you want to create. Some common images are as follows:

By giving BitBake the final target, it will work backward and build all the dependencies first, beginning with the toolchain. For now, we just want to create a minimal image to see how it works:

```bash
bitbake core-image-minimal
```

## Running the QEMU target

When you build a QEMU target, an internal version of QEMU is generated, which
removes the need to install the QEMU package for your distribution, and thus avoids
version dependencies. There is a wrapper script named runqemu we can use to run this
version of QEMU. To run the QEMU emulation, make sure that you have sourced oe-init-build-env,
and then just type this:

```bash
runqemu qemuarm
```

Log in as root, without a password. To close QEMU, close the framebuffer window.
To launch QEMU without the graphic window, add nographic to the command line:

```bash
runqemu qemuarm nographic
```
