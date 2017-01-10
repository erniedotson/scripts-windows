@echo off
rem **************************************************************************
rem Purpose:     Check for OS Version
rem Parameters:  N/A
rem Returns:     N/A
rem Notes:
rem             Sets OS_VERSION environment variable to the major.minor OS
rem             version
rem             Sets OS_NAME environment variable to the name of the OS
rem             version
rem References: 
rem             See http://msdn.microsoft.com/en-us/library/ms724832%28VS.85%29.aspx
rem             See http://stackoverflow.com/questions/13212033/get-windows-version-in-a-batch-file
rem **************************************************************************

set OS_VERSION=
set OS_NAME=

for /f "tokens=4-5 delims=. " %%i in ('ver') do set OS_VERSION=%%i.%%j
if "%OS_VERSION%" == "10.0" set OS_NAME=Windows 10
if "%OS_VERSION%" == "6.3"  set OS_NAME=Windows 8.1
if "%OS_VERSION%" == "6.2"  set OS_NAME=Windows 8
if "%OS_VERSION%" == "6.1"  set OS_NAME=Windows 7
if "%OS_VERSION%" == "6.0"  set OS_NAME=Windows Vista
if "%OS_VERSION%" == "5.2"  set OS_NAME=Windows XP Professional x64
if "%OS_VERSION%" == "5.1"  set OS_NAME=Windows XP
if "%OS_VERSION%" == "5.0"  set OS_NAME=Windows 2000
if "%OS_VERSION%" == "4.90" set OS_NAME=Windows ME
if "%OS_VERSION%" == "4.10" set OS_NAME=Windows 98
if "%OS_VERSION%" == "4.00" set OS_NAME=Windows 95
if "%OS_VERSION%" == "4.0"  set OS_NAME=Windows NT 4.0


echo OS_VERSION=%OS_VERSION%
echo OS_NAME=%OS_NAME%
