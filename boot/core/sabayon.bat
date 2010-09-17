@echo off
echo.
echo Running Sabayon in the QEMU virtual machine.
echo.
echo While running Sabayon in this mode, think of the following:
echo.
echo 1) Beware that your Microsoft Windows installations might have keyloggers,
echo viruses or other malware installed. Incognito's defenses can do nothing
echo against them.
echo.
echo 2) If you are using a persistent home volume your changes will not be saved
echo during this session but you will be able to access previously saved data. 
echo.
echo 3) Press CTRL-ALT to escape from the QEMU window, and CTRL-ALT-F to toggle
echo fullscreen mode.
echo.

set DRIVE=%CD:~0,1%

set KERNEL=sabayon
set INITRD=sabayon.igz
set KERNEL_ARGS=root=/dev/ram0 initrd=/boot/sabayon.igz aufs init=/linuxrc cdroot looptype=squashfs max_loop=64 loop=/livecd.squashfs splash=silent,theme:sabayon vga=791 console=tty1 quiet music
set SYSLINUX=boot

rem Start QEMU
start /B %DRIVE%:\qemu\qemu.exe -m 640M -localtime -soundhw sb16 -usb -L %DRIVE%:\qemu -hda fat:%DRIVE%: -kernel %DRIVE%:\%SYSLINUX%\%KERNEL% -initrd %DRIVE%:\%SYSLINUX%\%INITRD% -append "%KERNEL_ARGS%"
