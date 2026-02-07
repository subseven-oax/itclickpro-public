REM Fix Windows Update by renaming the SoftwareDistribution and catroot2 folders
REM This will force Windows Update to create new folders and download updates again, which can fix issues with Windows Update not working properly
REM Note that this will not delete the old folders, so if you need to restore them, you can just rename them back
REM This script should be run as an administrator, otherwise it will not have the necessary permissions to stop services and rename folders

REM Stop services
net stop wuauserv
net stop bits
net stop cryptsvc

REM Rename the folder where updates are stored

ren %Systemroot%\SoftwareDistribution SoftwareDistribution.old
ren %Systemroot%\System32\catroot2 catroot2.old

REM Restart services
net start wuauserv
net start bits
net start cryptsvc

REM Check for updates
wuauclt /detectnow
echo Windows Update has been reset. Please check for updates again.
