@echo off
rem **************************************************************************
rem Purpose:    Check for OS architecture
rem Parameters: N/A
rem Returns:    N/A
rem Notes:      Sets OS_ARCH environment variable to 32BIT or 64BIT
rem References: See http://support.microsoft.com/kb/556009
rem **************************************************************************

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS_ARCH=32BIT || set OS_ARCH=64BIT

if %OS_ARCH%==32BIT echo This is a 32bit operating system
if %OS_ARCH%==64BIT echo This is a 64bit operating system