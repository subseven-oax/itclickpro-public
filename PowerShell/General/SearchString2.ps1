param (
    [string]$SearchRoot = ".",
    [string[]]$SearchStrings = @("password", "secret", "token")
)

# Convert strings to hex
function ConvertTo-Hex {
    param ([string]$Text)
    return ($Text.ToCharArray() | ForEach-Object { [System.Text.Encoding]::UTF8.GetBytes($_) } | ForEach-Object { $_.ToString("X2") }) -join ""
}

$HexStrings = $SearchStrings | ForEach-Object { @{ Text = $_; Hex = ConvertTo-Hex $_ } }

# Search files
Get-ChildItem -Path $SearchRoot -Recurse -File | ForEach-Object {
    $FilePath = $_.FullName
    try {
        $Lines = Get-Content -Path $FilePath -ErrorAction Stop

        # Check plain text line-by-line
        for ($i = 0; $i -lt $Lines.Count; $i++) {
            foreach ($s in $SearchStrings) {
                if ($Lines[$i] -match [regex]::Escape($s)) {
                    Write-Output "Match in file: $FilePath"
                    Write-Output "  Found string: '$s'"
                    Write-Output "  Line $($i + 1): $($Lines[$i])"
                }
            }
        }

        # Check hex content
        $RawContent = [System.IO.File]::ReadAllBytes($FilePath)
        $HexContent = ($RawContent | ForEach-Object { $_.ToString("X2") }) -join ""

        foreach ($entry in $HexStrings) {
            if ($HexContent -match $entry.Hex) {
                Write-Output "Hex match in file: $FilePath"
                Write-Output "  Found hex string: '$($entry.Text)'"
            }
        }
    } catch {
        Write-Warning "Could not read file: $FilePath"
    }
}