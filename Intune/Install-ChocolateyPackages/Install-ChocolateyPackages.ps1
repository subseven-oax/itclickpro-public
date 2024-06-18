# This script can be run directly on a device or deployed with tools such as Intune (successfuly tested in Intune) 

# Define list of chocolatey packages to install, search packages names here https://community.chocolatey.org/packages
$ChocoPackages = @("adobereader","googlechrome","python3")
$ChocoInstall = Join-Path ([System.Environment]::GetFolderPath("CommonApplicationData")) "Chocolatey\bin\choco.exe"

# Install chocolatey if not installed
if(!(Test-Path $ChocoInstall)) {
	try {
		Invoke-Expression ((New-Object net.webclient).DownloadString('https://community.chocolatey.org/install.ps1')) -ErrorAction Stop
	}
	catch {
		Throw "Failed to install Chocolatey"
	}
}

# Install all chocolatey packages
Foreach($Package in $ChocoPackages) {
	try {
		Invoke-Expression "cmd.exe /c $ChocoInstall Install $Package -y" -ErrorAction Stop
	}
	catch {
		Throw "Failed to install $Package"
	}
}