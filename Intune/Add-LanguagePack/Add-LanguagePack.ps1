function Add-LanguagePack {
    <#
    .SYNOPSIS
        When adding certain languages to Windows that have multiple components for instance Japanese, some of these componenets are not present in the system, therefore, only basic components are added, in the case of Japanese, Hiragana is not added many times.
        This Function helps to solve this issue.

    .DESCRIPTION
        Installs Windows Language Packs in the system.
        This fuction only install all the required capabilities for a specific language but does not installs the actual language in the system, users would have to go to Settings > Time & Language to add it, but all required components will be available.
    .PARAMETER RegionTag
        RegionTag is the identification of the language to install, to see all possible RegionTags go to https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/available-language-packs-for-windows?view=windows-11
        For example, for Japanese use ja-JP, and for Spanish Mexico use es-MX.

    .EXAMPLE
        Add-LanguagePack -RegionTag 'ja-JP'

    .EXAMPLE
        Add-LanguagePack -RegionTag 'es-MX'

    .INPUTS
        String

    .OUTPUTS
        Success or Failure (0 or 1)

    .NOTES
        Author:  Victor Valentin
        GitHub URL: https://github.com/subseven-oax/itclickpro-public/tree/main/Intune/Add-LanguagePack
    #>
    param (
        [string[]]$RegionTag
    )
    $CapabilitiesFile = 'C:\Admin\capabilities.txt'
    $CapabilityList = Get-WindowsCapability -Online | Where-Object -Property 'Name' -match -Value $RegionTag | Format-List -Property Name | Out-File -FilePath $CapabilitiesFile
    (Get-Content $CapabilitiesFile) -replace “Name : ”, “” | Set-Content -Path $CapabilitiesFile
    [IO.File]::ReadAllText($CapabilitiesFile) -replace '\s+\r\n+', "`r`n" | Out-File $CapabilitiesFile

    for ($i=1; $i -le ((Get-Content $CapabilitiesFile).Length - 2) ; $i++)
    {
        try {
            $DismParameter = '/Online /Add-Capability /CapabilityName:' + (Get-Content $CapabilitiesFile | Select-Object -Index $i)
            Start-Process DISM.exe -ArgumentList $DismParameter -Wait -WindowStyle Hidden
        }
        catch {
            Write-Warning -Message "Unable to install capability"
        }
    }

exit $LASTEXITCODE    # Returns the value 0 if succeded, and 1 if failed - For reporting purposes only
}

# Calling Function
Add-LanguagePack -RegionTag 'el-GR'   # Adds Greek language components