@Echo off
REM Author: Victor Valentin
REM This script kicks off the seeding of files from a live Windows File Server to a another one, normally an upgraded version or simply to consolidate servers
REM Tested migrating file shares from Windows 2003 to Windows 2012 (this was a while back I know), it is assumed it would work on 2019/2022 servers but please test first
REM It is assumed that this script is run from the Destination Server, this will copy all files except the ones in use as they are locked by users
REM When the initial seeding is completed, reboot the server, and run the "FileServer_Migration_Copy_Changes.bat" batch file from the destibation server

REM The "scriptname" variable is used later to name the log file, therefore replace <server_name> with the relevant Server hostname (i.e. "FileServer01") to correctly identify the logfile later
REM Also, specify the path for the log file i.e. "C:\Reports"
set scriptname=InitialCopy_<server_name>
set logfile=<drive>:\<path>

REM For the source and destination you need to add the paths of what is being migrated, for example, to migrate a whole shared drive to a new DFS server:
REM set src="\\FileServer01\E$"
REM Set dst="E:\DFSRoots\FileServer01\E"
set src="\\<source_server>\<path>"
Set dst="<Drive>:\<destination_server_path>"

Title Migrating Data for %scriptname%

If not exist %logfile% mkdir %logfile%

robocopy %src% %dst% /e /zb /copyall /r:3 /w:3 /log:%logfile%\%scriptname%.log
