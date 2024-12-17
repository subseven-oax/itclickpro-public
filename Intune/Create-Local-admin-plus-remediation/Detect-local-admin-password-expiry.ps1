# Define the account name and password
$accountName = "ExistingUser"

# Check if the account exists
$account = Get-LocalUser -Name $accountName -ErrorAction SilentlyContinue

if ($account) {
        Write-Output "The account '$accountName' exists."
        Exit 1
} else {
    # Account does not exist
    Write-Output "The account '$accountName' doesn't exist."
    Exit 0
}