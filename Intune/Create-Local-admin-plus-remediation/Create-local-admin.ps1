# Define the account name and password
$accountName = "NewAdmin"
$password = "P@ssw0rd!"

# Check if the account exists
$account = Get-LocalUser -Name $accountName -ErrorAction SilentlyContinue

if ($account) {
    # Account exists
    Write-Output "The already exists."
} else {
    # Account does not exist, create a new local administrator account
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    New-LocalUser -Name $accountName -Password $securePassword -PasswordNeverExpires -AccountNeverExpires -FullName "Local Administrator" -Description "Local Administrator Account"
    Add-LocalGroupMember -Group "Administrators" -Member $accountName
    Write-Output "Account '$accountName' created and added to the Administrators group."
}