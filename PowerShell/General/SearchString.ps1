param (
    [string]$SearchRoot = ".",
    [string]$SearchString = "target"
)

# Convert the search string to its hexadecimal representation
function ConvertTo-Hex {
    param ([string]$Text)
    return ($Text.ToCharArray() | ForEach-Object { [System.Text.Encoding]::UTF8.GetBytes($_) } | ForEach-Object { $_.ToString("X2") }) -join ""
}

$HexString = ConvertTo-Hex -Text $SearchString

# Search through files
Get-ChildItem -Path $SearchRoot -Recurse -File | ForEach-Object {
    $FilePath = $_.FullName
    try {
        $Content = Get-Content -Path $FilePath -Raw -ErrorAction Stop

        $FoundPlain = $Content -match [regex]::Escape($SearchString)

        $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Content)
        $HexContent = ($Bytes | ForEach-Object { $_.ToString("X2") }) -join ""
        $FoundHex = $HexContent -match $HexString

        if ($FoundPlain -or $FoundHex) {
            Write-Output $FilePath
        }
    } catch {
        Write-Warning "Could not read file: $FilePath"
    }
}