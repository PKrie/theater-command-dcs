# Theater Command DCS
# GitHub DCS Commander
# Runtime Status

$dcsSms = Join-Path $env:USERPROFILE "..\..\Tools\dcs-sms\dcs-sms.exe"

if (!(Test-Path $dcsSms)) {
    $dcsSms = "C:\Tools\dcs-sms\dcs-sms.exe"
}

if (!(Test-Path $dcsSms)) {
    Write-Host ""
    Write-Host "ERROR: dcs-sms.exe not found."
    Write-Host ""
    Write-Host "Expected:"
    Write-Host "C:\Tools\dcs-sms\dcs-sms.exe"
    exit 1
}

Write-Host ""
Write-Host "======================================"
Write-Host " Theater Command GitHub DCS Commander"
Write-Host "======================================"
Write-Host ""

& $dcsSms status# Theater Command DCS
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
