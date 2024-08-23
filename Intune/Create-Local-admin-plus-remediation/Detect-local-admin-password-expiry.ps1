# Define the account name and password
$accountName = "ExistingAdmin"

# Check if the account exists
$account = Get-LocalUser -Name $accountName -ErrorAction SilentlyContinue

if ($account) {
    # Account exists, check if the password has expired
    if ($account.PasswordExpires) {
        Write-Output "The password for account '$accountName' has expired."
        Exit 1
    } else {
        Write-Output "The password for account '$accountName' has not expired."
        Exit 0
    }
} else {
    # Account does not exist
    Exit 0
}