# Define path for RustDesk executable
$FilePath = "C:\Program Files\RustDesk\rustdesk.exe"

# This function will return the latest version and download link as an object
function getLatest()
{
    $Page = Invoke-WebRequest -Uri 'https://github.com/rustdesk/rustdesk/releases/latest' -UseBasicParsing
    $HTML = New-Object -Com "HTMLFile"
    try
    {
        $HTML.IHTMLDocument2_write($Page.Content)
    }
    catch
    {
        $src = [System.Text.Encoding]::Unicode.GetBytes($Page.Content)
        $HTML.write($src)
    }

    # Current example link: https://github.com/rustdesk/rustdesk/releases/download/1.2.6/rustdesk-1.2.6-x86_64.exe
    $Downloadlink = ($HTML.Links | Where {$_.href -match '(.)+\/rustdesk\/rustdesk\/releases\/download\/\d{1}.\d{1,2}.\d{1,2}(.{0,3})\/rustdesk(.)+x86_64.exe'} | select -first 1).href

    # bugfix - sometimes you need to replace "about:"
    $Downloadlink = $Downloadlink.Replace('about:', 'https://github.com')

    $Version = "unknown"
    if ($Downloadlink -match './rustdesk/rustdesk/releases/download/(?<content>.*)/rustdesk-(.)+x86_64.exe')
    {
        $Version = $matches['content']
    }

    if ($Version -eq "unknown" -or $Downloadlink -eq "")
    {
        Write-Output "ERROR: Version or download link not found."
        Exit 1
    }

    # Create object to return
    $params += @{Version = $Version}
    $params += @{Downloadlink = $Downloadlink}
    $Result = New-Object PSObject -Property $params

    return($Result)
}

# Check if RustDesk.exe exists and if it is the latest version
Try {
    $check = Test-Path -Path $FilePath -ErrorAction Stop
    If ($check -eq $true){
        # Check if current installed RustDesk version is the latest
        $RustDeskOnGitHub = getLatest
        $rdver = ((Get-ItemProperty  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RustDesk\").Version)
        if ($rdver -eq $RustDeskOnGitHub.Version)
        {
            Write-Output "RustDesk $rdver is the newest version."
            Exit 0
        }
        else{
            Write-Warning "Installed version $rdver is not the latest version."
            Exit 1
        }
    }
    else {
        Write-Warning "RustDesk.exe does not exist."
        Exit 1
    } 
} 
Catch {
    Write-Warning "An error occurred: $_"
    Exit 1
}