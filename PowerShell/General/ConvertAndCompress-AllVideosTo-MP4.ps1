<#
Script to convert and compress video files to MP4 using FFmpeg
Converts MOV and MP4 files, excludes already converted files, and archives originals

.SYNOPSIS
Converts and compresses video files to MP4 using FFmpeg.

.DESCRIPTION
This script processes MOV and MP4 files in a source folder, converts them to MP4 with optional codecs/CRF,
ignores files already marked "_converted", and moves the originals to an archive folder.

.PARAMETER SourceFolder
Path to the folder containing source video files.

.PARAMETER ArchiveFolder
Path to the folder where original files will be archived after successful conversion.

.PARAMETER VideoCodec
(Optional) Video codec to use (default: libx264).

.PARAMETER Pixel_Format
(Optional) Pixel format to use (default: yuv420p).

.EXAMPLE
# basic usage with defaults
PS> .\ConvertAndCompress-AllVideosTo-MP4.ps1 -SourceFolder "C:\Videos" -ArchiveFolder "C:\Archive"

.EXAMPLE
# specify codecs and quality
PS> .\ConvertAndCompress-AllVideosTo-MP4.ps1 -SourceFolder "C:\Videos" -ArchiveFolder "C:\Archive" -VideoCodec h264_nvenc -Pixel_Format yuv420p
#>


param(
    [Parameter(Mandatory=$true)]
    [string]$SourceFolder,
    
    [Parameter(Mandatory=$true)]
    [string]$ArchiveFolder,
    
    [string]$VideoCodec = "libx264",
    [string]$Pixel_Format = "yuv420p"
)

# Validate source folder exists
if (-not (Test-Path $SourceFolder)) {
    Write-Error "Source folder not found: $SourceFolder"
    exit 1
}

# Create archive folder if it doesn't exist
if (-not (Test-Path $ArchiveFolder)) {
    Write-Host "Creating archive folder: $ArchiveFolder"
    New-Item -ItemType Directory -Path $ArchiveFolder -Force | Out-Null
}

# Get all MOV and MP4 files that don't end with "_converted"
$files = @(
    Get-ChildItem -Path $SourceFolder -Filter "*.MOV" -File
    Get-ChildItem -Path $SourceFolder -Filter "*.MP4" -File
) | Where-Object { $_.BaseName -notmatch "_converted$" }

if ($files.Count -eq 0) {
    Write-Host "No files to convert found in $SourceFolder"
    exit 0
}

Write-Host "Found $($files.Count) file(s) to process"

foreach ($file in $files) {
    $outputFileName = "$($file.BaseName)_converted$($file.Extension)"
    $outputPath = Join-Path $SourceFolder $outputFileName
    
    Write-Host "Converting: $($file.Name) -> $outputFileName"
    
    # Run FFmpeg conversion
    & ffmpeg -i "$($file.FullName)" -c:v $VideoCodec -pixel_format $Pixel_Format -y "$outputPath"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully converted: $($file.Name)"
        
        # Move original file to archive folder
        Move-Item -Path $file.FullName -Destination (Join-Path $ArchiveFolder $file.Name) -Force
        Write-Host "Archived original: $($file.Name)"
    }
    else {
        Write-Error "Failed to convert: $($file.Name)"
    }
}

Write-Host "Conversion process completed"