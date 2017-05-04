@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
rem **************************************************************************
rem Purpose:      List OneDrive conflicts
rem Parameters:   N/A
rem Returns:      0 - Sucess
rem               1 - Failure
rem Dependencies: N/A 
rem Notes:        Assumes OneDrive folder is in default location, user home
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

rem **************************************************************************
rem Uncomment for Debugging
rem **************************************************************************
rem @echo on
rem set some_param=some_value

rem **************************************************************************
rem *** Check script arguments
rem **************************************************************************
set param_noui=0

if "%1"=="" goto lbl_args_done
if /i "%1"=="/h" goto lbl_usage
if /i "%1"=="/noui" set param_noui=1&&goto lbl_args_done
goto lbl_usage
:lbl_args_done
goto lbl_begin

rem **************************************************************************
:lbl_begin
rem **************************************************************************

echo Checking for duplicate files in OneDrive folder...
set OD=%USERPROFILE%\OneDrive

if not exist "%OD%" echo OneDrive folder not found: %OD% & goto lbl_error

pushd "%OD%"
rem OneDrive appends "-COMPUTERNAME" to the filename (excluding extension) if
rem a merge conflict is detected.
dir *-%COMPUTERNAME%* /s /b 2>nul
set rc=%errorlevel%
popd

if %rc% EQU 0 (
    echo You should resolve the above conflicting OneDrive files ASAP.
) else (
    echo No conflicts found.
)
if "%param_noui%%rc%" == "00" pause

set rc=0

rem Success!
goto lbl_end

rem **************************************************************************
:lbl_usage
rem **************************************************************************
echo Lists OneDrive conflict files
echo.
echo %SCRIPT_NAME% [/F]
echo    /NOUI  Do not prompt for user input
echo    /H     Display this usage information
echo.
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
endlocal&&exit /B %rc%