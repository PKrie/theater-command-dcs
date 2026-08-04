# Theater Command DCS
# GitHub DCS Commander
# Runtime Status

$DcsSms = "C:\Tools\dcs-sms\dcs-sms.exe"

if (!(Test-Path $DcsSms)) {
    Write-Host ""
    Write-Host "ERROR: dcs-sms.exe not found."
    Write-Host "Expected path:"
    Write-Host $DcsSms
    exit 1
}

Write-Host ""
Write-Host "==============================="
Write-Host " Theater Command DCS Commander "
Write-Host " Runtime Status"
Write-Host "==============================="
Write-Host ""

& $DcsSms status
