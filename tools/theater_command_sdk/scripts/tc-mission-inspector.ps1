# Theater Command DCS
# GitHub DCS Commander
# Mission Inspector

$dcsSms = "C:\Tools\dcs-sms\dcs-sms.exe"

if (!(Test-Path $dcsSms)) {
    Write-Host ""
    Write-Host "ERROR: dcs-sms.exe not found."
    Write-Host "Expected path: $dcsSms"
    exit 1
}

Write-Host ""
Write-Host "========================================="
Write-Host " Theater Command Mission Inspector"
Write-Host "========================================="
Write-Host ""

Write-Host "--- Runtime Status ----------------------"
& $dcsSms status

Write-Host ""
Write-Host "--- Airbases ----------------------------"
& $dcsSms me airbase list

Write-Host ""
Write-Host "--- Zones -------------------------------"
& $dcsSms me zone list

Write-Host ""
Write-Host "--- Groups ------------------------------"
& $dcsSms me group list

Write-Host ""
Write-Host "--- Units -------------------------------"
& $dcsSms me unit list

Write-Host ""
Write-Host "--- Triggers ----------------------------"
& $dcsSms me trigger list

Write-Host ""
Write-Host "Inspection complete."
Write-Host ""