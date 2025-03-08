# Define the account name
$accountName = "ExistingAdmin"

# Check if the account exists
$account = Get-LocalUser -Name $accountName -ErrorAction SilentlyContinue

if ($account) {
    # Set account and password to never expire
    Set-LocalUser -Name $accountName -PasswordNeverExpires:$true -AccountNeverExpires:$true
    
    # Disable the option to change password at first logon
    $user = [adsi]"WinNT://$env:computername/$accountName"
    $user.UserFlags.value = $user.UserFlags.value -bor 0x10000
    $user.CommitChanges()

    Write-Output "Account '$accountName' has been modified: password and account set to never expire, and password change at first logon disabled."
} else {
    Write-Output "Account '$accountName' does not exist."
}