# This script has been tested on Windows x64 with Firefox x64 installed
# This script is to be deployed via Microsoft Intune
# Written by Victor Valentin

# Full path of uninstall executable file file
$file = 'C:\Program Files\Mozilla Firefox\uninstall\helper.exe'

# Check if helper.exe exists, tested on versions from 98.0.1 to 125.0.3
if  (Test-Path -Path $file -PathType Leaf) {
    try {
        # If helper.exe exists, runs the uninstallation process
        Start-Process $file -Wait -ArgumentList "/s" -Verb RunAs -WindowStyle Hidden
        }
    catch {
        throw $_.Exception.Message
        }
}

exit $LASTEXITCODE    # Returns the value 0 if succeded, and 1 if failed - For reporting purposes only