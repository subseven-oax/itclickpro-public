﻿# This script is intended to be used on Windows 10/11 x64 or ARM64 only. Architecture x86 not supported in this script.
# Checks online for the latest version of Zoom client and installs it or upgrades existing installation if required.
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

# Function to download and install Zoom
function Install-Zoom {
    $installerPath = "$env:TEMP\ZoomInstallerFull.msi"
    Invoke-WebRequest -Uri $zoomDownloadUrl -OutFile $installerPath
    Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /quiet /norestart MSIRESTARTMANAGERCONTROL=`"Disable`" ZConfig=`"nogoogle=1`" ZConfig=`"nofacebook=1`" ZRecommend=`"KeepSignedIn=1`" ZRecommend=`"AudioAutoAdjust=1`"" -Wait
    Remove-Item $installerPath
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
$zoomDownloadUrl = $zoomAppOnline.URI

# Get the installed version of Zoom
$installedVersion = Get-ZoomVersion
if ($installedVersion) {
    Write-Output "Zoom is installed. Version: $installedVersion"
    $zoomInst = [Version]$installedVersion
    $zoomLatest = [Version]$zoomAppOnline.Version
    if ($zoomLatest -gt $zoomInst) {
        Write-Output "Upgrading to the latest version..."
        Install-Zoom
    }
} else {
    Write-Output "Zoom is not installed. Installing the latest version..."
    Install-Zoom
}

Write-Output "Zoom installation or upgrade completed."