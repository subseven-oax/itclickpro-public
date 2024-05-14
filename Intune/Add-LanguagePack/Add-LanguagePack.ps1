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
    $CapabilityList = Get-WindowsCapability -Online | Where-Object -Property 'Name' -match -Value $RegionTag | Format-Table -Property Name

    foreach ($Capability in $CapabilityList) {
        try {
            $DismParameter = '/Online /Add-Capability /CapabilityName:' + $CapabilityList.Name
            Start-Process DISM.exe -ArgumentList $DismParameter -Verb RunAs -WindowStyle Hidden
        }
        catch {
            Write-Warning -Message "Unable to install capability"
        }
    }
exit $LASTEXITCODE    # Returns the value 0 if succeded, and 1 if failed - For reporting purposes only
}

# Calling Function
Add-LanguagePack -RegionTag 'el-GR'   # Adds Greek language components