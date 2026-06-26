# Deploy schedule task to upload BitLocker To Go Recovery Keys (for USB Keys) to AzureAD

Before we start, just a brief explanation of why I am deploying this scheduled task to devices.  When a USB device is encrypted using BitLocker To Go, the recovery key is not uploaded to AzureAD, instead the user needs to save/print a copy of the recovery key. This leave IT Admins with a big problem when a user calls for assistance to retrieve files from an USB drive encrypted with BitLocker To Go and the user forgets their password and where they saved the copy of the recovery key, or simply lost it.

This Schedule Task has been created to automatically upload a copy of the recovery key when the encryption of an USB key starts (EventID 24660).

Note that for this process targets Windows 10 and Windows 11 devices enrolled to Intune. It is also assumed that the devices have Internet connectivity when the scheduled task runs.

## Download .intunewin file

Download [ScheduledTask-USBRecoveryKeyAzureAD.intunewin](https://github.com/subseven-oax/itclickpro-public/blob/be6d126f5ea430f22859810ba324d31d88930b4c/Intune/ScheduleTask-UploadUSB-BitLocker-RecoveryKey/Register-ScheduledTask-USBRecoveryKeyAzureAD.intunewin)
This file will be used to create the Intune win32 App.  

NOTE: I tested successfully this file in two environments already (test and production), both deployed to Windows 10 x64 and Win 11 x64 devices, also to parallels VMs running on Macbooks with M processors.  But I suggest you also run your own tests and make adjustments as necessary. The .intunewin file in this test uses all files in this folder, if you are making changes to the powershell scripts or XML file, you need to re-package the files in a new .intunewin file.

## Create new App in Intune

1.- While in Intune, go to Apps > Windows.

2.- Click on Add, choose Windows App (Win32), and click on Select.

3.- Click on "Select app package file", and upload the .intunewin file previously downloaded, and click OK.

4.- Edit the Name and Description if you want, especify the Publisher name (other parameters are optional), and click on Next.

5.- Now especify the following, leave the rest with the default settings (these are the settings I tested), and click on Next when completed:

    Install command: powershell.exe -executionpolicy unrestricted .\Register-ScheduledTask-USBRecoveryKeyAzureAD.ps1

    Uninstall command: powershell.exe -executionpolicy unrestricted .\Unregister-ScheduledTask-USBRecoveryKeyAzureAD.ps1

    Installation time required (mins): 60

    Allow available uninstall: Yes

    Install behavior: System

6.- Under Requirements, I tested setting the Operating system architecture as 64-bit and Minimum operating system as Windows 10 20H2. Click on Next after setting your requirements.

7.- Under detection rules set Manually configure detection rules, then click on Add and select "File" as the rule type, then set the following:

    Path: C:\Admin\ScheduledTasks\USBRecoveryKeyAzureAD

    File or Folder: Unregister-ScheduledTask-USBRecoveryKeyAzureAD.ps1

    Detection Method: File or folder exists

    Associated with 32-bit app on 64-bit clients: No

8.- Click on Next until you get to Assinments, Select the group of devices you are deployint this scheduled task to, and click on Next.

9.- Review your information and Save the new App.

I hope this helps.
