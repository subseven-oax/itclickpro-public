# A schedule task is first manually created and tested on a device, the scheduled task is then exported to XML to be able to deploy it via MS Intune
# Define where the uninstall script, and script to upload BitLocker key will be stored
$scriptdir = "C:\Admin\ScheduledTasks\USBRecoveryKeyAzureAD"

# Force creation of folder
New-Item $scriptdir -ItemType Directory -Force

# Copy files to local folder
Copy-Item ".\Unregister-ScheduledTask-USBRecoveryKeyAzureAD.ps1" -Destination $scriptdir -Force
Copy-Item ".\Upload-USBRecoveryKeyAzureAD.ps1" -Destination $scriptdir -Force

# Create new schedule task, modify "ExportedScheduledTask.xml" to reflect your settings
Register-ScheduledTask -xml (Get-Content '.\ExportedScheduledTask.xml' | Out-String) -TaskName "Upload USB Recovery Key to AzureAD" -Force