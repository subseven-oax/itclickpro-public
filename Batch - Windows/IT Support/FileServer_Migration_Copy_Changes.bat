@Echo off
REM Author: Victor Valentin
REM This script completes the copy of remaining files that were locked when running the "FileServer_Migration_Initial_Seeding.bat"
REM NOTE that this script assumes the source server has been rebooted to unlock all files that were in use when running the initial seeding, this script will copy all differences.

REM The "scriptname" variable is used later to name the log file, therefore replace <server_name> with the relevant Server hostname (i.e. "FileServer01") to correctly identify the logfile later
REM Also, specify the path for the log file i.e. "C:\Reports"
set scriptname=MirrorCopy_<server_name>
set logfile=<drive>:\<path>

REM For the source and destination you need to add the paths of what is being migrated, for example, to migrate a whole shared drive to a new DFS server:
REM set src="\\FileServer01\E$"
REM Set dst="E:\DFSRoots\FileServer01\E"
set src="\\<source_server>\<path>"
Set dst="<Drive>:\<destination_server_path>"

Title Migrating Data for %scriptname%

If not exist %logfile% mkdir %logfile%

robocopy %src% %dst% /mir /sec /r:3 /w:3 /log:%logfile%\%scriptname%.log