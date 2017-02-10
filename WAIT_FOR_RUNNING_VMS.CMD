@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
rem **************************************************************************
rem Purpose:      Alert user if Virtual Machines are running and pause
rem Parameters:   N/A
rem Returns:      0 on Success
rem               1 on Error
rem Dependencies: N/A 
rem Notes:        Works with the following Hypervisors/providers:
rem               * Vagrant
rem               * VirtualBox
rem               * VMWare Workstation
rem               Assumes CLI executable for each is on path or in default
rem               installation location.
rem References:   N/A
rem **************************************************************************

rem **************************************************************************
rem *** Constants
rem **************************************************************************
set SCRIPT_NAME=%~n0

rem **************************************************************************
rem *** Global variables
rem **************************************************************************
set rc=0
set err_msg=
SET VAGRANT_TMP_FILE=
SET VBOX_TMP_FILE=
SET VM_TMP_FILE=

rem **************************************************************************
rem Uncomment for Debugging
rem **************************************************************************
rem @echo on
rem set some_param=some_value

rem **************************************************************************
rem *** Check script arguments
rem **************************************************************************
REM if "%1"=="" goto lbl_args_done
REM if /i "%1"=="/h" goto lbl_usage
REM if /i "%1"=="/f" set param_f=1&&goto lbl_args_done
REM goto lbl_usage
REM :lbl_args_done
REM goto lbl_begin

rem **************************************************************************
:lbl_begin
rem **************************************************************************

REM **************************************************************************
REM *** Check for Vagrants
REM **************************************************************************
ECHO.
ECHO Listing running Vagrants...

REM Check for vagrant.exe on path
WHERE /Q vagrant.exe && GOTO lbl_vagrant_found
IF EXIST "%SystemDrive%\HashiCorp\Vagrant\bin\vagrant.exe" (
  SET PATH="%PATH%;%SystemDrive%\HashiCorp\Vagrant\bin"
  GOTO lbl_vagrant_found
)
ECHO Could not find vagrant.exe. Skipping check for Vagrants.
GOTO lbl_vagrant_done

:lbl_vagrant_found
SET PATH_RND=%TEMP%\%SCRIPT_NAME%
SET VAGRANT_TMP_FILE=%PATH_RND%\%RANDOM%.TXT
IF NOT EXIST "%PATH_RND%" ( MKDIR "%PATH_RND%" || GOTO lbl_error )
vagrant global-status>"%VAGRANT_TMP_FILE%" || GOTO lbl_error
FINDSTR "running" "%VAGRANT_TMP_FILE%"
IF %ERRORLEVEL%==0 (
  PAUSE
) ELSE (
  ECHO No Vagrants running.
)
:lbl_vagrant_done

REM **************************************************************************
REM *** Check for VirtualBox VMs
REM **************************************************************************
ECHO.
ECHO Listing running VirtualBox VMs...

REM Find VBoxManage.exe
WHERE /Q VboxManage.exe && GOTO lbl_vbox_found
IF EXIST "%ProgramFiles%\Oracle\VirtualBox\VBoxManage.exe" (
  SET PATH="%PATH%;%ProgramFiles%\Oracle\VirtualBox"
  GOTO lbl_vbox_found
)
ECHO Could not find VBoxManage.exe. Skipping check for VirtualBox VMs.
GOTO lbl_vbox_done

:lbl_vbox_found
SET PATH_RND=%TEMP%\%SCRIPT_NAME%
SET VBOX_TMP_FILE=%PATH_RND%\%RANDOM%.TXT
IF NOT EXIST "%PATH_RND%" ( MKDIR "%PATH_RND%" || GOTO lbl_error )
VboxManage.exe list runningvms>"%VBOX_TMP_FILE%" || GOTO lbl_error
FINDSTR "{" "%VBOX_TMP_FILE%"
IF %ERRORLEVEL%==0 (
  PAUSE
) ELSE (
  ECHO No VirtualBox VMs running.
)
:lbl_vbox_done

REM **************************************************************************
REM *** Check for VMWare VMs
REM **************************************************************************
ECHO.
ECHO Listing running VMWare VMs...

REM Find VMRun.exe
WHERE /Q vmrun.exe && GOTO lbl_vmware_found
IF EXIST "%ProgramFiles(x86)%\VMware\VMware Workstation\vmrun.exe" (
  SET PATH="%PATH%;%ProgramFiles(x86)%\VMware\VMware Workstation"
  GOTO lbl_vmware_found
)
ECHO Could not find VMRun.exe. Skipping check for VMWare VMs.
GOTO lbl_vmware_done

:lbl_vmware_found
SET PATH_RND=%TEMP%\%SCRIPT_NAME%
SET VM_TMP_FILE=%PATH_RND%\%RANDOM%.TXT
IF NOT EXIST "%PATH_RND%" ( MKDIR "%PATH_RND%" || GOTO lbl_error )
vmrun.exe list>"%VM_TMP_FILE%" || GOTO lbl_error
FINDSTR ".vmx" "%VM_TMP_FILE%"
IF %ERRORLEVEL%==0 (
  PAUSE
) ELSE (
  ECHO No VMWare VMs running.
)
:lbl_vmware_done

rem Success!
goto lbl_end

rem **************************************************************************
:lbl_usage
rem **************************************************************************
REM echo Prints Hello World
REM echo.
REM echo %SCRIPT_NAME% [/F]
REM echo    /F  Force a failure
REM echo    /H  Display this usage information
REM echo.
REM goto lbl_end

rem **************************************************************************
:lbl_error
rem **************************************************************************
set rc=1
echo.
echo An error ocurred:
echo     %err_msg%
echo %SCRIPT_NAME% script is halting.
goto lbl_end

rem **************************************************************************
:lbl_end
rem **************************************************************************
IF EXIST "%VAGRANT_TMP_FILE%" DEL "%VAGRANT_TMP_FILE%" 1>NUL
IF EXIST "%VBOX_TMP_FILE%" DEL "%VBOX_TMP_FILE%" 1>NUL
IF EXIST "%VM_TMP_FILE%" DEL "%VM_TMP_FILE%" 1>NUL
endlocal&&exit /B %rc%