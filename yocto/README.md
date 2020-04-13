# Yocto

This directory contains everything you need to build the Linux distribution for your LitSpin.

## Description

This folder contains 3 directories:
* litbuild directory: this is the build directory. It will contain every file created by Yocto but it also coantains the configuration fils for the build.
* meta-litspin: this directory contains our meta layer we created for Yocto. It contains every recipe we made to customize our distibution.
* prebuild-patches: this folder contains a patch. This patch is a modification that we were unable to include in a recipe.

We realized differents modifications:
* A different default configuration for openssh
* Add a startup script to automatically connect to WiFi at boot
* Build a driver for our USB WiFi dongle and add it to the kernel
* Add our own Device Tree
* Change kernel config to deal with WiFi issue

## Getting Started
These instructions will explain you how to build the distribution and how to install it

### Prerequisites

You will need the prerequisites of the Yocto project for the thud version (2.6.4). You can find them [here](https://www.yoctoproject.org/docs/2.6.4/mega-manual/mega-manual.html#detailed-supported-distros).

Moreover, we advise you to build the distribution with a lot of threads available and at least 50 Gio available. For instance, it takes 20-30 minutes to build for a 144 threads computer.

To install the distribution on the MCV you will also need a Mini USB cable, a MCVEVP board and a USB to serial cable. You can find one on ARIES website.

### Building
If you want to build the distribution, simply run the following command
```
make
```
### Installing on the board
An image archive has been created and the path to it is `litbuild/tmp/deploy/images/mcvevk/litspin-image-mcvevk.wic.xz`.

The steps to install it on the MCV are:

First, go in the same folder as the `litspin-image-mcvevk.wic.xz` archive.
Then, extract the image from the archive with `unxz`
```
unxz litspin-image-mcvevk.wic.xz
```
You can add the `-k` option to keep the archive. Without this option, the archive would be deleted.

If a distribution is already present with U-Boot, apply the following steps. However, follow the [MCV_recovery](../MCV_recovery/README.md) steps.

#### Prepare the board
Plug the USB to serial cable on the UART port and open a console on your host PC and start a tty console like tio for instance, connect to your target. The parameters are the default parameters for tio:
* Baud rate: 115,200
* Data bits: 8
* No flow control
* Stop bit: 1
* No parity 
* No output delay

Connect power supply to the board. The board will boot. Then, stop the automatic boot by typing a key. Enter the following command
```
ums 0 mmc 0
```
The host PC will detect a new USB storage device, which can be used as a regular USB stick. Use __VERY CAREFULLY__ the dd tool to copy the .wic image into the USB Mass Storage detected by the computer. If you do a mistake in the `of` parameter you can break some partitions on your computer.

For instance, on my computer, the USB Mass Storage device location was /dev/sdb so the command I used was:
```
sudo dd if=core-image-full-cmdline-aries-mcvevk.wic of=/dev/sdb
```
To know the location of the USB Mass Storage device, use the command `lsblk`.

When the transfer is finished, press CTRL+C in the serial console to stop the USB mode. Then use the command `reset` to restart the board.