#Detect the Removable Drive letters
#Taken from https://stackoverflow.com/questions/10634396/get-the-drive-letter-of-usb-drive-in-powershell
# This script can be called by a schedule task deployed via Intune

$RemDrive = gwmi win32_diskdrive | ?{$_.interfacetype -eq "USB"} | %{gwmi -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=`"$($_.DeviceID.replace('\','\\'))`"} WHERE AssocClass = Win32_DiskDriveToDiskPartition"} | %{gwmi -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=`"$($_.DeviceID)`"} WHERE AssocClass = Win32_LogicalDiskToPartition"} | %{$_.deviceid}

#Store the recovery key to AzureAD with the device record
#Based on https://docs.microsoft.com/en-us/powershell/module/bitlocker/backup-bitlockerkeyprotector?view=windowsserver2019-ps

$BLV = Get-BitLockerVolume -MountPoint $RemDrive 
BackupToAAD-BitLockerKeyProtector -MountPoint $RemDrive -KeyProtectorId $BLV.KeyProtector[1].KeyProtectorId