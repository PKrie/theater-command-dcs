# Theater Command DCS
# GitHub DCS Commander
# Mission Report

$dcsSms = "C:\Tools\dcs-sms\dcs-sms.exe"

if (!(Test-Path $dcsSms)) {
    Write-Host ""
    Write-Host "ERROR: dcs-sms.exe not found."
    exit 1
}

Write-Host ""
Write-Host "======================================"
Write-Host " Theater Command Mission Report"
Write-Host "======================================"
Write-Host ""

Write-Host "=== Runtime Status ==="
& $dcsSms status

Write-Host ""
Write-Host "=== Last 50 DCS Log Lines ==="
& $dcsSms tail-log -n 50