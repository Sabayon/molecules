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

rem Start QEMU

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" goto 64BIT

rem 32bit
start /B %DRIVE%:\qemu\qemu.exe -m 768M -localtime -soundhw sb16 -usb -L %DRIVE%:\qemu -cdrom %DRIVE%:
goto END

:64BIT
start /B %DRIVE%:\qemu\qemu-system-x86_64.exe -m 768M -localtime -soundhw sb16 -usb -L %DRIVE%:\qemu -cdrom %DRIVE%:

:END
