# A schedule task is first manually created and tested on a device, the scheduled task is then exported to XML to be able to deploy it via MS Intune
# Define where the uninstall script, and script to upload BitLocker key will be stored
$scriptdir = "C:\Admin\ScheduledTasks\USBRecoveryKeyAzureAD"

# Force creation of folder
New-Item $scriptdir -ItemType Directory -Force

# Copy files to local folder
Copy-Item ".\Unregister-ScheduledTask-USBRecoveryKeyAzureAD.ps1" -Destination $scriptdir -Force
Copy-Item ".\Upload-USBRecoveryKeyAzureAD.ps1" -Destination $scriptdir -Force

# Create new schedule task, modify "Upload-USBRecoveryKeyAzureAD.xml" to reflect the name of your XML file, the XML file in this repo has been created on a Windows 11 machine but it also works on Windows 10
Register-ScheduledTask -xml (Get-Content '.\Upload-USBRecoveryKeyAzureAD.xml' | Out-String) -TaskName "Upload USB Recovery Key to AzureAD" -Force