Hi, welcome to Sabayon for the BeagleBone.

First of all, you may want to install the image into a new SDHC card.
Make sure to have enough space for it, for example, if you downloaded
the 4GB version, make sure you're using a 4GB SDHC stick.

Other requirements:
-------------------

  - a Linux distro to copy the image to the SDHC
  - a SDHC reader
  - a root shell on the Linux distro


How to burn the image:
----------------------

Insert the SDHC memory into your reader (make sure that the LOCK
switch is turned off). After a few seconds, type:

  # dmesg | tail -n 10

In the last kernel message lines you will be able to read the
actual device name, might be something like "sdc" or in general
"sdX" where X is just a letter.
Make sure to see the same device name inside /dev directory.

Once you got the name, just dump the image into that, in this
example, we assume that the device is /dev/sdc and the image
name is "Sabayon_Linux_8_armv7a_BeagleBoard_xM_4GB.img".
Do this as root!

  # xzcat Sabayon_Linux_8_armv7a_BeagleBoard_xM_4GB.img > /dev/sdd

Once it is done, check for any error using:

  # dmesg | tail -n 10

And if it's all good, type:

  # sync; sync; sync

To make sure everything has been flushed to the device.

At this point, extract your SDHC and place it into the BeagleBone.
You're set!


How to change keyboard mapping:
-------------------------------

Our images come with "keyboard-setup", a shell too that lets you easily
do this, just type:

  # keyboard-setup "<your keyboard layout code>" all

Then reboot!


How to change language:
-----------------------

Open /etc/locale.gen and add your locale (you can find a full list
at: /usr/share/i18n/SUPPORTED).
Make sure to add UTF-8 locales, this is what we support.
Once you've added your line, just type:

  # language-setup "<your locale, without the .UTF-8 part>" system

Then reboot!


You want to know more?
----------------------
Just go to http://www.sabayon.org and to http://wiki.sabayon.org
and search for "BeagleBoard".
We're full of guides.


Contact
-------
Just mail us at website@sabayon.org if you need any help or register
to our mailing list at http://lists.sabayon.org/cgi-bin/mailman/listinfo/devel

