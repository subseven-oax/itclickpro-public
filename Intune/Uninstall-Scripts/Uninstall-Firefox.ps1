# This script uninstalls Mozilla Firefox
# Source:  https://www.hexnode.com/mobile-device-management/help/script-to-install-and-uninstall-mozilla-firefox-on-windows-devices/

try 
{
$appExists = $true 
$filePath = "C:\Program Files\Mozilla Firefox\uninstall\helper.exe" 
if(-not(Test-Path $filePath)) 
{ 
$filePath = "C:\Program Files (x86)\Mozilla Firefox\uninstall\helper.exe" 
if(-not(Test-Path $filePath)) 
{ 
$appExists = $false 
} 
}
if($appExists) 
{
Start-Process -FilePath $filePath -ArgumentList "/s" -Wait
Write-Host "Successfully uninstalled Firefox application." 
}
else
{
Write-Host "Firefox is not installed on this device.”} 
}
catch 
{ 
Write-Host $_.Execption.Message 
}