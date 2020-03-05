# Recovery procedure for MCV

You will need a Mini USB cable, a MCVEVP board and a USB to serial cable. You can find one on ARIES website.

## Modify boot settings
Close Jumper P32 on MCVEVP.
## Connect USB Blaster and USB A-miniB cable
On MCVEVP connect the USB blaster to header P8 (pin 1 of P8 is closest to the SoM) and to a host PC. Connect the
USB A-miniB cable to the USB miniB connector P201 and a host PC.
## Open a Console
Plug the USB to serial cable on the UART port and open a console2 on your host PC and start a tty console like tio for instance, connect to your target. The parameters are the default parameters for tio:
* Baud rate: 115,200
* Data bits: 8
* No flow control
* Stop bit: 1
* No parity 
* No output delay

## Power up the board
Connect power supply to the board. The board will produce no console output, yet.
## Start Quartus Programmer
Start Altera Quartus II software , from the Tools drop-down menu, select the “Programmer” tool. In the newly invoked
“Programmer”:
17MCV Quick Start Guide, Release 2
1. Click ‘Auto-Detect’ in the left hand panel
2. In the ‘Select Device’ dialog, select your device (depending on the SoM) and click OK. For our SOM it is the 5CSEBA6
3. In the top part of main pane, right-click ‘5CSxx’ and select
‘Change File’. Don't worry if it doesn't match the name on the device.
4. In the ‘Select New Programming File’, select the file ‘Recovery-C2.sof’ or ‘Recovery-C6.sof’ (depending on
the SoM). For our MCV it is Recovery-C6.sof
5. In the top part of main pane, check the ‘Program/Configure’ box for the ‘5CSxx'
(depending on the SoM)
6. Click ‘Start’ in the left hand panel
Note
Please contact ARIES Embedded to obtain your version of the correct rescue image for MCV. You will the rescue image for the Aries MCV A5/A6
## Use USB Mass Storage
After the programming finished, the board comes up and immediately starts USB Mass Storage mode. The USB Mass
Storage is backed by the eMMC integrated on the MCV SoM. You can see it on the serial console.

The host PC will detect a new USB storage device, which can be used as a regular USB stick. Use __VERY CAREFULLY__ the dd tool to copy the .wic image into the USB Mass Storage detected by the computer. If you do a mistake in the `of` parameter you can break some partitions on your computer.

For instance, on my computer running Ubuntu, the USB Mass Storage device name was /dev/sdb so the command I used was:
```
unxz core-image-full-cmdline-aries-mcvevk.wic.xz  #To extract the WIC image
sudo dd if=core-image-full-cmdline-aries-mcvevk.wic of=/dev/sdb
```
To know the name of the USB Mass Storage device, use the command `lsblk`.

When the transfer is finished, press CTRL+C in the serial console to stop the USB mode. Then you can disconnect power supply from the board and you can remove P32 jumper to go back to a normal boot.

# Troubleshootings
## Quartus doesn't find the FPGA
Be sure the SW1 switches follow this configuration for switches 6-7-8:

|Switch| Signal | Default configuration |
|:-----|:-------|:----------------------|
|6     |MCV_TDO |on                     |
|7     |MCV_TDO |off                    |
|8     |HSMC_TDO|off                    |


Check MCV Quick Start Guide for more information