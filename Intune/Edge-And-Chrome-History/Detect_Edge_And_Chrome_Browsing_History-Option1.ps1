# Define the file path
$filePath = "C:\\Admin\\chrome_history.csv"

# Check if the file exists
if (Test-Path $filePath) {
    # Get the file's last write time
    $lastWriteTime = (Get-Item $filePath).LastWriteTime

    # Calculate the time difference
    $timeDifference = (Get-Date) - $lastWriteTime

    # Check if the file is older than 1 day
    if ($timeDifference.Days -ge 1) {   #  You can change the number of days so the collection of history isn't done every day
        Write-Output "The file is older than 1 day."
        Exit 1
    } else {
        Write-Output "The file is not older than 1 day."
        Exit 0
    }
} else {
    Write-Output "The file does not exist."
    Exit 1
}