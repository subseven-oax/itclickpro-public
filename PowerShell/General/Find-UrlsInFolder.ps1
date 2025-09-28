param (
    [string]$SearchRoot = "."
)

# Regex pattern to match URLs with optional port number
$UrlPattern = '(https?|ftp):\/\/[^\s\/:]+(:\d+)?[^\s]*'

# Convert bytes to hex string
function ConvertTo-HexString {
    param ([byte[]]$Bytes)
    return ($Bytes | ForEach-Object { $_.ToString("X2") }) -join ""
}

# Convert hex string back to text
function ConvertFrom-Hex {
    param ([string]$Hex)
    $Bytes = for ($i = 0; $i -lt $Hex.Length; $i += 2) { [Convert]::ToByte($Hex.Substring($i, 2), 16) }
    return [System.Text.Encoding]::UTF8.GetString($Bytes)
}

# Search files
Get-ChildItem -Path $SearchRoot -Recurse -File | ForEach-Object {
    $FilePath = $_.FullName
    try {
        # Plain text search
        $Lines = Get-Content -Path $FilePath -ErrorAction Stop
        for ($i = 0; $i -lt $Lines.Count; $i++) {
            if ($Lines[$i] -match $UrlPattern) {
                $Matches = [regex]::Matches($Lines[$i], $UrlPattern)
                foreach ($m in $Matches) {
                    Write-Output "Plain URL found in: $FilePath"
                    Write-Output "  Line $($i + 1): $($Lines[$i])"
                    Write-Output "  URL: $($m.Value)"
                }
            }
        }

        # Hex search
        $RawBytes = [System.IO.File]::ReadAllBytes($FilePath)
        $HexContent = ConvertTo-HexString -Bytes $RawBytes

        # Search for hex-encoded URLs
        $HexUrlPattern = '68(?:74|74|74|70|73|66|74)3A2F2F[0-9A-F]{2,}'  # crude match for hex-encoded http(s):// or ftp://
        $HexMatches = [regex]::Matches($HexContent, $HexUrlPattern)
        foreach ($hm in $HexMatches) {
            $Decoded = ConvertFrom-Hex -Hex $hm.Value
            if ($Decoded -match $UrlPattern) {
                Write-Output "Hex URL found in: $FilePath"
                Write-Output "  Decoded URL: $Decoded"
            }
        }
    } catch {
        Write-Warning "Could not read file: $FilePath"
    }
}