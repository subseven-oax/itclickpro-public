# This script is intended to be used on Windows 10/11 x64 or ARM64 only. Architecture x86 not supported in this script.
# Checks online for the latest version of FoxitReader client and installs it or upgrades existing installation if required.
# Please note it installs the Evergreen PowerShell module https://www.powershellgallery.com/packages/Evergreen/
# This script could be modified to work with other applications supported by the Evergreen module
# Run "Get-EvergreenEndpoint" to see the list of Apps supported by Evergreen

# Written by Victor Valentin

# Function to get the installed version of FoxitReader using WMI
function Get-FoxitReaderVersion {
    try {
        $FoxitReaderApp = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "FoxitReader*" }
        if ($FoxitReaderApp) {
            return $FoxitReaderApp.Version
        }
    } catch {
        Write-Output "An error occurred while retrieving the FoxitReader version."
        return $null
    }
    return $null
}

# Function to check if a PowerShell module is installed
function Test-ModuleInstalled {
    param (
        [string]$moduleName
    )
    $module = Get-Module -ListAvailable -Name $moduleName
    return $null -ne $module
}

# Function to install a PowerShell module
function Install-ModuleIfNotInstalled {
    param (
        [string]$moduleName
    )
    if (-not (Test-ModuleInstalled -moduleName $moduleName)) {
        Write-Output "Module '$moduleName' is not installed. Installing..."
        Install-Module -Name $moduleName -Force -Scope AllUsers
    } else {
        Write-Output "Module '$moduleName' is already installed."
    }
}

# Function to download and install FoxitReader
function Install-FoxitReader {
    $installerPath = "$env:TEMP\FoxitReaderInstallerFull.msi"
    Invoke-WebRequest -Uri $FoxitReaderDownloadUrl -OutFile $installerPath
    Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /quiet /norestart" -Wait
    Remove-Item $installerPath
}

# Check and install the Evergreen module if not installed
Install-ModuleIfNotInstalled -moduleName "Evergreen"
Import-Module Evergreen

# Get URL for the latetest version of FoxitReader available online
$FoxitReaderAppOnline = Invoke-EvergreenApp -Name FoxitReader| Where-Object {$_.Language -eq 'English'}
$FoxitReaderDownloadUrl = $FoxitReaderAppOnline.URI

# Get the installed version of FoxitReader
$installedVersion = Get-FoxitReaderVersion
if ($installedVersion) {
    Write-Output "FoxitReader is installed. Version: $installedVersion"
    $FoxitReaderInst = [Version]$installedVersion
    $FoxitReaderLatest = [Version]$FoxitReaderAppOnline.Version
    if ($FoxitReaderLatest -gt $FoxitReaderInst) {
        Write-Output "Upgrading to the latest version..."
        Install-FoxitReader
    }
} else {
    Write-Output "FoxitReader is not installed. Installing the latest version..."
    Install-FoxitReader
}

Write-Output "FoxitReader installation or upgrade completed."