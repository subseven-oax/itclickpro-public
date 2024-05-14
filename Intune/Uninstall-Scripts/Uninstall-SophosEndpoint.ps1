# This script has being written assuming Tamper Protection has been disabled on the devices
# This script is to be deployed via Microsoft Intune
# Written by Victor Valentin

# Full path of executable file file
$file = 'C:\Program Files\Sophos\Sophos Endpoint Agent\SophosUninstall.exe'
$file2 = 'C:\Program Files\Sophos\Sophos Endpoint Agent\uninstallgui.exe'

# Check if SophosUninstall.exe exists, this is for Core Agent 2022.4 and later
if  (Test-Path -Path $file -PathType Leaf) {
    try {
        # Sophos Agent uninstallation only happens if the SophosUninstall.exe file exists
        Start-Process $file -Wait -ArgumentList "--quiet" -Verb RunAs -WindowStyle Hidden
        }
    catch {
        throw $_.Exception.Message
        }
}

# Check if uninstallgui.exe exists, this is for Core Agent 2022.2 and older
if  (Test-Path -Path $file2 -PathType Leaf) {
    try {
        # Sophos Agent uninstallation only happens if the SophosUninstall.exe file exists
        Start-Process $file2 -Wait -ArgumentList "--quiet" -Verb RunAs -WindowStyle Hidden
        }
    catch {
        throw $_.Exception.Message
        }
}
exit $LASTEXITCODE    # Returns the value 0 if succeded, and 1 if failed - For reporting purposes only