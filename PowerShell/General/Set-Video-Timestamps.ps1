## .SYNOPSIS
##     Changes the creation date of converted MP4 files based on the date in their filename.
## 
## .DESCRIPTION
##     This script processes all MP4 files ending with "_Converted.mp4" in a specified folder.
##     It extracts the date/time from the filename (in format 'yyyymmdd_hhmmss' or 'yyyy-mm-dd hh-mm-ss')
##     and updates the file's creation date accordingly.
## 
## .PARAMETER FolderPath
##     The folder path containing the MP4 files to process.
## 
## .EXAMPLE
##     .\Set-Video-Timestamps.ps1 -FolderPath "E:\Automatic Upload\Samsung SM-S938B\DCIM\Camera"
##

Param(
    [Parameter(Mandatory=$true)]
    [string]$FolderPath
)

# Ensure folder exists
if (-not (Test-Path $FolderPath)) {
    Write-Error "Folder not found: $FolderPath"
    exit
}

# Pattern matches filenames beginning with either:
# 1) yyyyMMdd_HHmmss
# 2) yyyy-MM-dd HH-mm-ss
# Followed by optional text and ending with _Converted.mp4 (case-insensitive)
$regex = '^(?<date1>\d{8}_\d{6})|(?<date2>\d{4}-\d{2}-\d{2} \d{2}-\d{2}-\d{2})'

Get-ChildItem -Path $FolderPath -Filter "*_Converted*.mp4" | ForEach-Object {
    $file = $_
    $name = $file.Name

    # Try to extract either date format
    $match = [regex]::Match($name, $regex)

    if (-not $match.Success) {
        Write-Warning "Could not extract timestamp from file: $name"
        return
    }

    # Decide which format matched
    $timestampText = if ($match.Groups["date1"].Success) {
        $match.Groups["date1"].Value
    } elseif ($match.Groups["date2"].Success) {
        $match.Groups["date2"].Value
    }

    # Convert extracted text into a [datetime] object
    try {
        if ($timestampText -match '^\d{8}_\d{6}$') {
            # Format yyyyMMdd_HHmmss
            $dt = [datetime]::ParseExact($timestampText, "yyyyMMdd_HHmmss", $null)
        }
        elseif ($timestampText -match '^\d{4}-\d{2}-\d{2} \d{2}-\d{2}-\d{2}$') {
            # Format yyyy-MM-dd HH-mm-ss
            $dt = [datetime]::ParseExact($timestampText, "yyyy-MM-dd HH-mm-ss", $null)
        }
        else {
            throw "Unknown timestamp format in $timestampText"
        }
    }
    catch {
        Write-Warning "Failed to parse datetime for $name : $_"
        return
    }

    # Apply the times
    try {
        $file.CreationTime = $dt
        $file.LastWriteTime = $dt

        Write-Host "Updated: $name → $dt"
    }
    catch {
        Write-Warning "Failed to update timestamps for $name : $_"
    }
}