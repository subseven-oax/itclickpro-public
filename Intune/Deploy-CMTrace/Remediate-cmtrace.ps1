# Download CMTrace from your own shared Cloud File Storage (OneDrive, SharePoint, GoogleDrive, GitHub, etc.) and save it in C:\Windows\System32
$FileURL = "https://github.com/......."   # Make sure you change the URL
invoke-webrequest -uri $FileURL -outfile "C:\Windows\System32\cmtrace.exe"
