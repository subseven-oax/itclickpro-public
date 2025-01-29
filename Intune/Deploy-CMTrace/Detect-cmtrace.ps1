# Define path for CMTrace
$FilePath = "c:\windows\system32\cmtrace.exe"

# Test if CMTrace.exe exists
Try {
    $check = Test-Path -Path $FilePath -ErrorAction Stop
    If ($check -eq $true){
        Write-Output "Compliant"
        Exit 0
    } 
    Write-Warning "Not Compliant"
    Exit 1
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}