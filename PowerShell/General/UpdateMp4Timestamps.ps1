<#
.SYNOPSIS
    Updates the CreationTime of MP4 files based on timestamps embedded in their filenames.

.DESCRIPTION
    This script scans a specified directory for MP4 files ending in '_Converted'. It parses the filename 
    using regular expressions to extract date and time information (supporting 'yyyymmdd_hhmmss' or 
    'yyyy-mm-dd hh-mm-ss' formats) and applies that timestamp to the file's CreationTime property.

.PARAMETER FolderPath
    The full path to the directory containing the MP4 files you wish to process.

.EXAMPLE
    .\UpdateVideoDates.ps1 -FolderPath "C:\Users\Name\Videos\Converted"
    Processes all matching files in the specified folder and updates their creation dates.
#>
param (
    [Parameter(Mandatory=$true, HelpMessage="Enter the path to the folder containing your MP4 files.")]
    [string]$FolderPath
)

# Get all MP4 files ending in _Converted.mp4
$files = Get-ChildItem -Path $FolderPath -Filter "*_Converted.mp4" -File

foreach ($file in $files) {
    $foundDate = $null
    $fileName = $file.BaseName 

    # Pattern 1: yyyymmdd_hhmmss (e.g., 20231025_143005)
    if ($fileName -match '(\d{8})_(\d{6})') {
        $dateStr = $Matches[1]
        $timeStr = $Matches[2]
        $format = "yyyyMMdd_HHmmss"
        $foundDate = [datetime]::ParseExact("$dateStr`_$timeStr", $format, $null)
    }
    # Pattern 2: yyyy-mm-dd hh-mm-ss (e.g., 2023-10-25 14-30-05)
    elseif ($fileName -match '(\d{4}-\d{2}-\d{2})\s(\d{2}-\d{2}-\d{2})') {
        $datePart = $Matches[1]
        $timePart = $Matches[2]
        $format = "yyyy-MM-dd HH-mm-ss"
        $foundDate = [datetime]::ParseExact("$datePart $timePart", $format, $null)
    }

    if ($foundDate) {
        Write-Host "Updating $($file.Name) to $foundDate" -ForegroundColor Cyan
        $file.CreationTime = $foundDate
    } else {
        Write-Warning "Could not parse date from filename: $($file.Name)"
    }
}
