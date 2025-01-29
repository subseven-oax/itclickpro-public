# Define Add-in DLL file path
$DllFile = "C:\Program Files\Adobe\Acrobat DC\PDFMaker\Common\PDFMakerAPI.dll"
# Get signature from Add-in DLL file
$FileSignature = Get-AuthenticodeSignature -FilePath $DllFile
# Get certificate from signature
$FileCertificate = $FileSignature.SignerCertificate
# Export certificate to Base64 format
$B64Cert = [System.Convert]::ToBase64String(([System.Security.Cryptography.X509Certificates.X509Certificate2]::new($FileCertificate)).Export('Cert'))
Write-Output $B64Cert
# Get the certificate Thumbprint
Write-Output $FileCertificate.thumbprint