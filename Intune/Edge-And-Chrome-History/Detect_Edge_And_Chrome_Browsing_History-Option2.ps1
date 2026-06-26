# Define the file path

$filePath = "$Env:SystemDrive\Users\$Env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\History" # Path to Chrome "History" file
# Check if Chrome history file exists
if (Test-Path $filePath) {
    Write-Output "Chrome history file exists."
    Exit 1
} else {
    $filePath = "$Env:systemdrive\Users\$UserName\AppData\Local\Microsoft\Edge\User Data\Default\History"  # Path to Edge "History" file
    # Check if Edge history file exists
    if (Test-Path $filePath) {
        Write-Output "Edge history file exists."
        Exit 1
    } else {
        Write-Output "Neither Chrome or Edge history files exist"
        Exit 0
    }
}