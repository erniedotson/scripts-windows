@echo off
rem **************************************************************************
rem Purpose:    Check for OS Version
rem Parameters: N/A
rem Returns:    N/A
rem Notes:      Sets environment variables: OS_VER_MAJOR, OS_VER_MINOR,
rem             OS_VER_BUILD
rem             Sets OS_VERSION environment variable to the major.minor OS
rem             version
rem             Sets OS_NAME environment variable to the name of the OS
rem             version
rem References:
rem             See http://msdn.microsoft.com/en-us/library/ms724832%28VS.85%29.aspx
rem             See http://stackoverflow.com/questions/13212033/get-windows-version-in-a-batch-file
rem             See http://ss64.com/nt/ver.html
rem             See https://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx
rem **************************************************************************

set OS_VERSION=
set OS_VER_MAJOR=
set OS_VER_MINOR=
set OS_VER_BUILD=
set OS_NAME=

for /f "tokens=4,5,6 delims=[]. " %%G in ('ver') Do (set OS_VER_MAJOR=%%G& set OS_VER_MINOR=%%H& set OS_VER_BUILD=%%I) 

goto sub%OS_VER_MAJOR%%OS_VER_MINOR%
 
:sub51
:sub52
set OS_NAME=Windows XP/Windows Server 2003
goto next
 
:sub60
set OS_NAME=Windows Vista/Windows Server 2008
goto next
 
:sub61
set OS_NAME=Windows 7/Windows Server 2008 R2
goto next
 
:sub62
set OS_NAME=Windows 8/Windows Server 2012
goto next
 
:sub63
set OS_NAME=Windows 8.1/Windows Server 2012 R2
goto next
 
:sub100
:sub101
set OS_NAME=Windows 10/Windows Server 2016
 
:next
set OS_VERSION=%OS_VER_MAJOR%.%OS_VER_MINOR%

rem echo OS_VERSION=%OS_VERSION%
rem echo OS_VER_MAJOR=%OS_VER_MAJOR%
rem echo OS_VER_MINOR=%OS_VER_MINOR%
rem echo OS_VER_BUILD=%OS_VER_BUILD%
rem echo OS_NAME=%OS_NAME%