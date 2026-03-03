<#
.SYNOPSIS
    Changes the creation date of converted MP4 files based on the date in their filename.

.DESCRIPTION
    This script processes all MP4 files ending with "_Converted.mp4" in a specified folder.
    It extracts the date/time from the filename (in format 'yyyymmdd_hhmmss' or 'yyyy-mm-dd hh-mm-ss')
    and updates the file's creation date accordingly.

.PARAMETER FolderPath
    The folder path containing the MP4 files to process.

.EXAMPLE
    .\Change-CreationDate.ps1 -FolderPath "C:\Videos"
#>

param(
    [Parameter(Mandatory = $true, HelpMessage = "Please provide a valid folder path")]
    [ValidateScript({
        if (-not (Test-Path -Path $_ -PathType Container)) {
            throw "Folder path '$_' does not exist or is not a directory."
        }
        $true
    })]
    [string]$FolderPath
)

# Get all converted MP4 files
$files = Get-ChildItem -Path $FolderPath -Filter "*_Converted.mp4" -File -ErrorAction SilentlyContinue

if ($files.Count -eq 0) {
    Write-Warning "No files matching '*_Converted.mp4' found in '$FolderPath'."
    exit 0
}

Write-Host "Found $($files.Count) file(s) to process."

foreach ($file in $files) {
    try {
        # Extract potential date from filename
        $filename = $file.BaseName
        $dateMatch = $null
        $extractedDate = $null

        # Try format: yyyymmdd_hhmmss
        if ($filename -match '^\d{8}_\d{6}') {
            $dateString = $matches[0]
            $dateMatch = [DateTime]::ParseExact($dateString, 'yyyymmdd_HHmmss', $null)
            $extractedDate = $dateMatch
        }
        # Try format: yyyy-mm-dd hh-mm-ss
        elseif ($filename -match '^\d{4}-\d{2}-\d{2}\s\d{2}-\d{2}-\d{2}') {
            $dateString = $matches[0]
            $dateMatch = [DateTime]::ParseExact($dateString, 'yyyy-MM-dd HH-mm-ss', $null)
            $extractedDate = $dateMatch
        }

        if ($null -eq $extractedDate) {
            Write-Warning "Could not extract valid date from filename: '$($file.Name)'. Skipping."
            continue
        }

        # Update file creation and modification times
        $file.CreationTime = $extractedDate
        $file.LastWriteTime = $extractedDate

        Write-Host "✓ Updated '$($file.Name)' to $($extractedDate.ToString('yyyy-MM-dd HH:mm:ss'))"
    }
    catch [System.FormatException] {
        Write-Warning "Invalid date format in filename '$($file.Name)'. Skipping."
    }
    catch {
        Write-Error "Error processing file '$($file.Name)': $($_.Exception.Message)"
    }
}

Write-Host "Batch conversion complete."