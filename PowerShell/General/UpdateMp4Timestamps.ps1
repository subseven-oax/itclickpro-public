<#
.SYNOPSIS
    Updates the Creation, LastWrite, and LastAccess timestamps of MP4 files based on
    timestamps embedded in their filenames.

.DESCRIPTION
    This script processes MP4 files inside a specified folder whose names end with
    "_Converted.mp4". It extracts a timestamp from the filename using one of three
    supported patterns and applies that timestamp to the file's metadata.

    Supported filename timestamp formats:
        1. yyyymmdd_hhmmss*_Converted.mp4
        2. yyyy-mm-dd hh-mm-ss*_Converted.mp4
        3. yyyy.mm.dd hh.mm.ss*_Converted.mp4   (new third pattern)

    The script supports:
        - Dry-run mode (no changes applied)
        - CSV logging of all actions
        - A progress bar for large folders
        - Safe error handling and clear output

.PARAMETER FolderPath
    The folder containing the MP4 files to process.

.PARAMETER DryRun
    When specified, the script will not modify any file timestamps. It will only
    display what would have been changed.

.PARAMETER LogPath
    Optional path to a CSV log file. If not provided, a log file will be created
    in the script directory.

.EXAMPLE
    PS> .\UpdateMp4Timestamps.ps1 -FolderPath "C:\Videos"

    Processes all *_Converted.mp4 files in C:\Videos and updates their timestamps.

.EXAMPLE
    PS> .\UpdateMp4Timestamps.ps1 -FolderPath "C:\Videos" -DryRun

    Shows what changes would be made without modifying any files.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$FolderPath,

    [switch]$DryRun,

    [string]$LogPath = "$PSScriptRoot\TimestampUpdateLog.csv"
)

# Validate folder
if (-not (Test-Path $FolderPath)) {
    Write-Error "Folder path does not exist: $FolderPath"
    exit
}

# Prepare log file
if (-not (Test-Path $LogPath)) {
    "FileName,ExtractedTimestamp,Status,Notes" | Out-File -FilePath $LogPath -Encoding UTF8
}

# Regex patterns
$pattern1 = '^(?<date>\d{8})_(?<time>\d{6}).*_Converted\.mp4$'                     # yyyymmdd_hhmmss
$pattern2 = '^(?<date>\d{4}-\d{2}-\d{2}) (?<time>\d{2}-\d{2}-\d{2}).*_Converted\.mp4$' # yyyy-mm-dd hh-mm-ss
$pattern3 = '^(?<date>\d{4}\.\d{2}\.\d{2}) (?<time>\d{2}\.\d{2}\.\d{2}).*_Converted\.mp4$' # yyyy.mm.dd hh.mm.ss

Write-Host "`nScanning folder: $FolderPath"
Write-Host "Dry-run mode: $DryRun"
Write-Host "Log file: $LogPath`n"

$files = Get-ChildItem -Path $FolderPath -Filter "*_Converted.mp4"
$total = $files.Count
$index = 0

foreach ($file in $files) {

    $index++
    Write-Progress -Activity "Processing MP4 files" -Status "File $index of $total" -PercentComplete (($index / $total) * 100)

    $fileName = $file.Name
    $timestamp = $null
    $status = "Failed"
    $notes = ""

    # Pattern 1
    if ($fileName -match $pattern1) {
        $dateString = $Matches['date']
        $timeString = $Matches['time']

        $dateFormatted = "{0}-{1}-{2}" -f $dateString.Substring(0,4), $dateString.Substring(4,2), $dateString.Substring(6,2)
        $timeFormatted = "{0}:{1}:{2}" -f $timeString.Substring(0,2), $timeString.Substring(2,2), $timeString.Substring(4,2)

        try { $timestamp = Get-Date "$dateFormatted $timeFormatted" } catch { $notes = "Invalid timestamp (pattern1)" }
    }
    # Pattern 2
    elseif ($fileName -match $pattern2) {
        $dateString = $Matches['date']
        $timeString = $Matches['time'] -replace '-', ':'

        try { $timestamp = Get-Date "$dateString $timeString" } catch { $notes = "Invalid timestamp (pattern2)" }
    }
    # Pattern 3 (new)
    elseif ($fileName -match $pattern3) {
        $dateString = $Matches['date'] -replace '\.', '-'
        $timeString = $Matches['time'] -replace '\.', ':'

        try { $timestamp = Get-Date "$dateString $timeString" } catch { $notes = "Invalid timestamp (pattern3)" }
    }
    else {
        $notes = "Filename did not match any known patterns"
    }

    if ($timestamp) {
        Write-Host "Processing: $fileName"
        Write-Host " → Extracted timestamp: $timestamp"

        if (-not $DryRun) {
            try {
                $file.CreationTime = $timestamp
                $file.LastWriteTime = $timestamp
                $file.LastAccessTime = $timestamp
                $status = "Success"
                $notes = "Timestamps updated"
            }
            catch {
                $notes = "Error applying timestamps: $_"
            }
        }
        else {
            $status = "DryRun"
            $notes = "No changes applied"
        }
    }
    else {
        Write-Warning "Skipping $fileName — $notes"
    }

    # Log entry
    "$fileName,$timestamp,$status,$notes" | Out-File -FilePath $LogPath -Append -Encoding UTF8
}

Write-Host "`nCompleted. Log saved to: $LogPath`n"
