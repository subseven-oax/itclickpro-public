$scriptdir = "c:\Admin\ScheduledTasks\ChocoUpgradeAll"
New-Item $scriptdir -ItemType Directory -Force
Copy-Item ".\Unregister-ScheduledTask-UpdateChocolateyPackages.ps1" -Destination $scriptdir -Force
Register-ScheduledTask -xml (Get-Content '.\UpdateAllChocolateyPackages.xml' | Out-String) -TaskName "Update All Chocolatey Packages" -Force