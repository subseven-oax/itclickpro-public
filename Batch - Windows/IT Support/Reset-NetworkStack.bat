@echo off
REM Reset Network Stack Script
REM This script resets the network stack on Windows using ipconfig and netsh commands

setlocal enabledelayedexpansion
title Network Stack Reset Utility

REM Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    pause
    exit /b 1
)
REM Display script purpose
echo.
echo Reset the following network components:
echo - DNS cache
echo - DHCP leases
echo - TCP/IP stack
echo - Winsock catalog
echo - Winsock proxy
echo.
echo.
echo ========================================
echo     Network Stack Reset Utility
echo ========================================
echo.
echo This will reset your network configuration.
echo.
pause

REM Flush DNS cache
echo [*] Flushing DNS cache...
ipconfig /flushdns
if %errorlevel% equ 0 echo [+] DNS cache flushed successfully.

REM Release and renew DHCP leases
echo [*] Releasing DHCP leases...
ipconfig /release
timeout /t 2 /nobreak

echo [*] Renewing DHCP leases...
ipconfig /renew

REM Reset IP stack
echo [*] Resetting IP stack...
netsh int ip reset resetlog.txt
if %errorlevel% equ 0 echo [+] IP stack reset successfully.

REM Reset TCP stack
echo [*] Resetting TCP stack...
netsh interface tcp reset resetlog.txt
if %errorlevel% equ 0 echo [+] TCP stack reset successfully.

REM Reset Winsock catalog
echo [*] Resetting Winsock catalog...
netsh winsock reset catalog
if %errorlevel% equ 0 echo [+] Winsock catalog reset successfully.

REM Reset Winsock proxy settings
echo [*] Resetting Winsock proxy...
netsh winhttp reset proxy

REM Display new network configuration
echo.
echo [*] Current network configuration:
ipconfig /all

echo.
echo ========================================
echo     Reset Complete
echo ========================================
echo.
echo A system restart is recommended for all changes to take effect.
pause