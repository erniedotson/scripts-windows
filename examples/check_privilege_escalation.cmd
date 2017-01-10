@echo off
rem *** Check if we are running 'as admin' ***
net session >nul 2>&1 && echo Running 'As Administrator'. || echo No Administrator privileges. Try again from an Administrative Command Prompt.
