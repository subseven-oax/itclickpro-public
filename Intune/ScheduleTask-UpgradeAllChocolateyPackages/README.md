# Deploy schedule task to upgrade all Chocolatey packages installed on a device

Before we start, just a brief explanation of why I am deploying this scheduled task to devices.  [Chocolatey] (https://chocolatey.org/) is package manager for Windows used to deploy software to devices. After a package is installed on a device users can manually upgrade the packages installed by running the command 'choco upgrade all -y' or by using the Chocolatey GUI if installed.

This Schedule Task has been created to automatically upgrade all installed packages by calling the command described above, the task runs every third Thursday of the month at 1pm.

Note that for this process targets Windows 10 and Windows 11 devices enrolled to Intune. It is also assumed that the devices have Internet connectivity when the scheduled task runs.

## Download .intunewin file

Download [Register-ScheduledTask-UpdateChocolateyPackages.intunewin](https://github.com/subseven-oax/itclickpro-public/blob/39e8073e0e88d426669db2d0f79b687a9694c33b/Intune/ScheduleTask-UpgradeAllChocolateyPackages/Register-ScheduledTask-UpdateChocolateyPackages.intunewin)
This file will be used to create the Intune win32 App. 

NOTE: I tested successfully this file in two environments already (test and production), both deployed to Windows 10 x64 and Win 11 x64 devices, also to parallels VMs running on Macbooks with M processors.  But I suggest you also run your own tests and make adjustments as necessary. The .intunewin file in this test uses all files in this folder, if you are making changes to the powershell scripts or XML file, you need to re-package the files in a new .intunewin file.

## Create new App in Intune

1.- While in Intune, go to Apps > Windows.

2.- Click on Add, choose Windows App (Win32), and click on Select.

3.- Click on "Select app package file", and upload the .intunewin file previously downloaded, and click OK.

4.- Edit the Name and Description if you want, especify the Publisher name (other parameters are optional), and click on Next.

5.- Now especify the following, leave the rest with the default settings (these are the settings I tested), and click on Next when completed:

    Install command: powershell.exe -executionpolicy unrestricted .\Register-ScheduledTask-UpdateChocolateyPackages.ps1

    Uninstall command: powershell.exe -executionpolicy unrestricted .\Unregister-ScheduledTask-UpdateChocolateyPackages.ps1

    Installation time required (mins): 60

    Allow available uninstall: Yes

    Install behavior: System

6.- Under Requirements, I tested setting the Operating system architecture as 64-bit and Minimum operating system as Windows 10 20H2. Click on Next after setting your requirements.

7.- Under detection rules set Manually configure detection rules, then click on Add and select "File" as the rule type, then set the following:

    Path: c:\Admin\ScheduledTasks\ChocoUpgradeAll

    File or Folder: Unregister-ScheduledTask-UpdateChocolateyPackages.ps1

    Detection Method: File or folder exists

    Associated with 32-bit app on 64-bit clients: No

8.- Click on Next until you get to Assinments, Select the group of devices you are deployint this scheduled task to, and click on Next.

9.- Review your information and Save the new App.

I hope this helps.
