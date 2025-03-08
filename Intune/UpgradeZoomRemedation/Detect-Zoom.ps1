# This script is intended to be used on Windows 10/11 x64 or ARM64 only. Architecture x86 not supported in this script.
# This script detects if a Zoom upgrade or new installation needs to be done, the remediation script will be triggered if the version is outdated.
# Please note it installs the Evergreen PowerShell module https://www.powershellgallery.com/packages/Evergreen/
# This script could be modified to work with other applications supported by the Evergreen module
# Run "Get-EvergreenEndpoint" to see the list of Apps supported by Evergreen

# Written by Victor Valentin

# Function to get the installed version of Zoom using WMI
function Get-ZoomVersion {
    try {
        $zoomApp = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "Zoom*" }
        if ($zoomApp) {
            return $zoomApp.Version
        }
    } catch {
        Write-Output "An error occurred while retrieving the Zoom version."
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

# Check and install the Evergreen module if not installed
Install-ModuleIfNotInstalled -moduleName "Evergreen"
Import-Module Evergreen

# Detect the system architecture, get URL and version of zoom available online
$architecture = $Env:PROCESSOR_ARCHITECTURE
if ($architecture -eq "ARM64") {
    $zoomAppOnline = Invoke-EvergreenApp -Name Zoom| Where-Object {$_.Type -eq 'msi' -and ($_.Platform -eq 'Desktop') -and ($_.Architecture -eq 'ARM64')}
} else {
    $zoomAppOnline = Invoke-EvergreenApp -Name Zoom| Where-Object {$_.Type -eq 'msi' -and ($_.Platform -eq 'Desktop') -and ($_.Architecture -eq 'x64')}
}

# Get the installed version of Zoom
$installedVersion = Get-ZoomVersion
if ($installedVersion) {
    Write-Output "Zoom is installed. Version: $installedVersion"
    $zoomInst = [Version]$installedVersion
    $zoomLatest = [Version]$zoomAppOnline.Version
    if ($zoomLatest -gt $zoomInst) {
        Exit 1
    }
    else
    {
        Exit 0
    }
}
else {
    Exit 1
}