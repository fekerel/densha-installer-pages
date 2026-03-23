@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-densha.ps1" -InstallRoot "%~dp0densha"
pause
