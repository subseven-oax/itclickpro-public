function Add-LanguagePack {
    param (
        [string[]]$RegionTag
    )
    $Capabilities = Get-WindowsCapability -Online | Where-Object -Property 'Name' -match -Value $RegionTag;

    foreach ($Name in $Capabilities) {
        try {
            $Results = Add-WindowsCapability -Online -Name $Name -ErrorAction SilentlyContinue
        }
        catch {
            Write-Warning -Message "Unable to install capability"
        }
    }
exit $LASTEXITCODE    # Returns the value 0 if succeded, and 1 if failed - For reporting purposes only
}