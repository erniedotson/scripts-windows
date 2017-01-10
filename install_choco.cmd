@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
rem **************************************************************************
rem Purpose:      Install Chocolatey Package Manager from
rem               https://chocolatey.org/
rem               Also installs chocolatey package - to manage itself
rem Returns:      0 on Success
rem               1 on Error
rem               3010 on Reboot is required
rem Dependencies: PowerShell v3 or greater
rem               refreshenv.cmd - Installed by Chocolatey
rem Notes:        See https://chocolatey.org/
rem **************************************************************************

rem **************************************************************************
rem *** Constants
rem **************************************************************************
set RC_REBOOT_REQUIRED=3010
set SCRIPT_NAME=%~n0

rem **************************************************************************
rem *** Global variables
rem **************************************************************************
set rc=0
set err_msg=
set choco_param_limitoutput=
set choco_param_noop=
set force_install=0

rem **************************************************************************
rem Uncomment for Debugging
rem **************************************************************************
rem set choco_param_noop=--noop
rem set choco_param_limitoutput=--limitoutput


rem **************************************************************************
rem *** Check script arguments
rem **************************************************************************
if "%1"=="" goto lbl_args_done
if /i "%1"=="/h" goto lbl_usage
if /i "%1"=="/f" set force_install=1&&goto lbl_args_done
goto lbl_usage
:lbl_args_done
goto lbl_begin

rem **************************************************************************
rem *** Begin main execution
rem **************************************************************************
:lbl_begin

rem *** Check for privilege escalation ***
net session >nul 2>&1 || (
  set err_msg=Administrator privileges required. Try again from an Administrative Command Prompt.
  goto lbl_error
)

rem **************************************************************************
rem *** Check if we need to install choco
rem **************************************************************************

rem If user has forced install, skip the check and go straight to install
if %force_install%==1 goto lbl_install_choco

rem Check if it's already installed
echo.
echo | set /p dummy="Searching for choco.exe... "
where /q choco && (
  echo Chocolatey Package Manager already installed. Your system has not been modified.
  goto lbl_end
)

rem **************************************************************************
rem *** Install Chocolatey
rem **************************************************************************
:lbl_install_choco
echo.
echo Installing Chocolatey Package Manager...
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && set PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
where /q choco || (
  set err_msg=Failed to find or install choco.exe.
  goto lbl_end
)
call refreshenv.cmd
rem On Win7, Chocolatey will install .Net Framework 4.0 if it's not already installed,
rem but IF it does this, a restart is required for chocolatey executables to
rem run correctly.
rem IF we are here, chocolatey was installed and choco.exe exists, lets see
rem if it runs!
choco list -lo >NUL || (
  echo Chocolatey failed to run after installation. This is usually caused by a pending reboot after installing .Net Framework.
  goto lbl_reboot
)
:CHOCO_END

rem Let Chocolatey manage itself
cinst -y chocolatey %choco_param_limitoutput% %choco_param_noop%
if "%errorlevel%"=="%RC_REBOOT_REQUIRED%" goto lbl_reboot
if "%errorlevel%" NEQ "0" (
  set err_msg=Failed to install chocolatey package
  goto lbl_error
)

rem Make sure chocolatey is latest version
cup -y chocolatey %choco_param_limitoutput% %choco_param_noop%
if "%errorlevel%"=="%RC_REBOOT_REQUIRED%" goto lbl_reboot
if "%errorlevel%" NEQ "0" (
  set err_msg=Failed to update chocolatey package
  goto lbl_error
)

rem *** Success ***
goto lbl_end

rem **************************************************************************
rem *** Usage
rem **************************************************************************
:lbl_usage
echo Installs the latest version of Chocolatey Package Manager if not already
echo installed.
echo.
echo %SCRIPT_NAME% [/F]
echo    /F  Force install/upgrade if chocolatey is already installed
echo    /H  Display this usage information
echo.
goto :lbl_end

rem **************************************************************************
:lbl_reboot
rem **************************************************************************
set rc=%RC_REBOOT_REQUIRED%
echo.
echo A reboot is required. Please reboot and run %SCRIPT_NAME% again to continue.
goto lbl_end

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
ENDLOCAL&&EXIT /B %rc%