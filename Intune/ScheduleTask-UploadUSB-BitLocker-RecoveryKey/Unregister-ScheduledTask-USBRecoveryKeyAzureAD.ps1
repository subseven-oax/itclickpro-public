# Delete scheduled task, note that the task name must match the name given in Register-ScheduledTask-USBRecoveryKeyAzureAD.ps1
unregister-scheduledtask -taskname "Upload USB Recovery Key to AzureAD" -confirm:$false