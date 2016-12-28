@echo off
net stop wuauserv || goto ERR
echo Deleting Windows Update cache files...
PUSHD "%Windir%\SoftwareDistribution" || goto ERR
DEL /F /S /Q Download || goto ERR
POPD || goto ERR
net start wuauserv || goto ERR
goto DONE

:ERR
echo An error ocurred. Script terminating.
pause

:DONE