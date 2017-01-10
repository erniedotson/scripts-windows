@echo off
rem Recursively delete thumbnail files from current directory.
rem This targets Windows thumbs.db and Mac .DS_Store files.
del /s /q thumbs.db
del /s /q .DS_Store