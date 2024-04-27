# Script to configure regional settings to English UK on Azure Virtual Machines
# Author: Victor Valentin
# Pre-requisite:  Have the XML file exported from a machine with the right settings, and make the file available over the internet i.e. stored in GitHub or any other platform
# In this example the XML file is stored in my public GitHub repo and it the file contains English UK configuration

# Downdload XML file
$XMLfileURL = "https://raw.githubusercontent.com/subseven-oax/AzureVM-Personalization/main/AzureVM-GB-XMLfile.xml"  # Replace URL with the one for your XML file
$XMLfile = "D:\AzureVM-GB-XMLfile.xml"   # Set the temporal location of the XML file in the Virtual Machine, most Windows Azure VMs have a D: drive
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($XMLfileURL,$XMLfile)


# Set regional settings using XML file
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"$XMLfile`""

# Set languages
Set-WinSystemLocale en-GB     # For Language Code IDentifiers (LCID) see https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-lcid/70feba9f-294e-491e-b6eb-56532684c37f 
Set-WinUserLanguageList -LanguageList en-GB -Force
Set-Culture -CultureInfo en-GB
Set-WinHomeLocation -GeoId 242     # Change value according to your needs, for other regions check https://learn.microsoft.com/en-gb/windows/win32/intl/table-of-geographical-locations?redirectedfrom=MSDN 
Set-TimeZone -Name "GMT Standard Time"   # run "Get-TimeZone -ListAvailable | Format-Table" to get a list of the different Time Zones to choose the one you need

# restart virtual machine to apply regional settings
Start-sleep -Seconds 40
Restart-Computer
