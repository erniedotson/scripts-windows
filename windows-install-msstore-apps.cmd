@echo off
setlocal

@REM Winget Error codes
@REM See: https://github.com/microsoft/winget-cli/blob/master/doc/windows/package-manager/winget/returnCodes.md
set APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE_CODE=-1978335189
set APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE_MSG=No applicable update found
set APPINSTALLER_CLI_ERROR_SHELLEXEC_INSTALL_FAILED_CODE=-1978335226
set APPINSTALLER_CLI_ERROR_SHELLEXEC_INSTALL_FAILED_MSG=Running ShellExecute failed


call :printBanner "Resetting Microsoft Store..."
wsreset -i || goto error
@REM winget install 9WZDNCRFJBMP​

call :printBanner "Installing latest version of Winget..."
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Add-AppxPackage https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" || goto error

call :printBanner "Upgrading Winget..."
winget upgrade Microsoft.AppInstaller
call :handleWinGetError %errorlevel% || goto error

call :printBanner "Installing packages..."
winget install Microsoft.PCManager --scope user
call :handleWinGetError %errorlevel% || goto error
winget install "Microsoft To Do"
call :handleWinGetError %errorlevel% || goto error

call :printBanner "Upgrading existing packages..."
winget upgrade --all
call :handleWinGetError %errorlevel% || goto error

echo.
echo "We're done!"
exit /b 0

:error
echo.
echo An error was encountered and script has terminated. 1>&2
endlocal & exit /b 1

@REM **************************************************************************
@REM FUNCTIONS
@REM **************************************************************************

:printBanner
	echo.
	echo **************************************************************
	echo * %~1
	echo **************************************************************
goto :eof

:printError
	echo ERROR: %~1 1>&2
goto :eof

:printWinGetError
    if "%~1" EQU "%APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE_CODE%" ( echo %APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE_MSG%
    ) else ( echo Unkown Winget Error: %~1 1>&2 )
goto :eof

:handleWinGetError
    @REM Print the message, then return 1 if critical error, 0 if benign error
    if "%~1" EQU "0" ( echo OK & exit /b 0
    ) else if "%~1" EQU "%APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE_CODE%" ( echo %APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE_MSG% & exit /b 0
    ) else if "%~1" EQU "%APPINSTALLER_CLI_ERROR_SHELLEXEC_INSTALL_FAILED_CODE%" ( echo %APPINSTALLER_CLI_ERROR_SHELLEXEC_INSTALL_FAILED_MSG% & exit /b 1)
    ) else ( echo Unkown Winget Error: %~1 1>&2 & exit /b 1 )
goto :eof
