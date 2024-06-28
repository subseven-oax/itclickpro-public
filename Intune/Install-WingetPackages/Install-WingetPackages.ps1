# This script can be run directly on a device or deployed with tools such as Intune (successfuly tested in Intune)
# This was also successfuly tested in a Windows Sandbox VM

# Define list of Winget ID packages to install, on a device with winget install use the 'winget search <AppName>' command to find the package IDs and sources
$WingetPackages = @("9NZVDKPMR9RD","XPFCG5NRKXQPKT","XP9KHM4BK9FZ7Q")  # This example installs Firefox, Foxit Reader and Visual Studio Code
$WingetSource = @("msstore","msstore","msstore")  # Define the source of the package "msstore" or "winget" (in this case all are from "msstore"), you must define one per package to install

# Check if Winget is installed
$wingetInstalled = Get-Command winget -ErrorAction SilentlyContinue

if (-not $wingetInstalled) {
    # Get the latest download URL for Winget
    $progressPreference = 'silentlyContinue'
	Write-Information "Downloading WinGet, its dependencies, and install them"
	Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
	Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
	Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
	Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
	Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
	Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Write-Host "Winget has been installed successfully!"
} else {
    Write-Host "Winget is already installed."
}

# Install all Winget packages
$i = 0
Foreach($Package in $WingetPackages) {
	$WingetCommand = "winget install " + $Package + " --silent --source " + $WingetSource[$i] + " --accept-source-agreements --accept-package-agreements"
	write-host $WingetCommand
	try {
		Invoke-Expression "cmd.exe /c $WingetCommand" -ErrorAction Stop

	}
	catch {
		Throw "Failed to install $Package"
	}
	$i++
}
exit $LASTEXITCODE    # Returns the value 0 if succeded, and 1 if failed - For reporting purposes only