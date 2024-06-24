# This script can be run directly on a device or deployed with tools such as Intune (successfuly tested in Intune)
# This was also successfuly tested in a Windows Sandbox VM

# Define list of Winget ID packages to install, on a device with winget install use the 'winget search <AppName>' command to find the package IDs
$WingetPackages = @("9NZVDKPMR9RD","7zip.7zip","XP9KHM4BK9FZ7Q")  # This example installs Firefox, 7-Zip and Visual Studio Code

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
Foreach($Package in $WingetPackages) {
	try {
		Invoke-Expression "cmd.exe /c winget install $Package --silent --accept-source-agreements --accept-package-agreements" -ErrorAction Stop
	}
	catch {
		Throw "Failed to install $Package"
	}
}
exit $LASTEXITCODE    # Returns the value 0 if succeded, and 1 if failed - For reporting purposes only