@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
rem **************************************************************************
rem Purpose:      The Purpose
rem Parameters:   N/A
rem Returns:      0 - Sucess
rem               1 - Failure
rem Dependencies: N/A 
rem Notes:        Some Notes
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
if "%1"=="" goto lbl_args_done
if /i "%1"=="/h" goto lbl_usage
if /i "%1"=="/f" set param_f=1&&goto lbl_args_done
goto lbl_usage
:lbl_args_done
goto lbl_begin

rem **************************************************************************
rem *** Begin main execution
rem **************************************************************************
:lbl_begin

echo Hello World
if %param_f%==1 set err_msg=Param F specified&&goto lbl_error



rem Success!
goto lbl_end

rem **************************************************************************
rem *** Usage
rem **************************************************************************
:lbl_usage
echo Prints Hello World
echo.
echo %SCRIPT_NAME% [/F]
echo    /F  Force a failure
echo    /H  Display this usage information
echo.
goto :lbl_end

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


