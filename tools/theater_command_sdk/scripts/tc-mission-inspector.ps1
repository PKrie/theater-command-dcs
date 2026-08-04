# Theater Command DCS
# Theater Command SDK
# Mission Inspector

$ErrorActionPreference = "Stop"

$dcsSms = "C:\Tools\dcs-sms\dcs-sms.exe"

if (!(Test-Path $dcsSms)) {
    Write-Host ""
    Write-Host "ERROR: dcs-sms.exe not found."
    Write-Host "Expected path: $dcsSms"
    exit 1
}

function Invoke-DcsSmsJson {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    $rawOutput = & $dcsSms @Arguments 2>&1
    $exitCode = $LASTEXITCODE

    if ($exitCode -ne 0) {
        throw "DCS-SMS command failed: $($Arguments -join ' ')`n$($rawOutput -join [Environment]::NewLine)"
    }

    $jsonText = $rawOutput -join [Environment]::NewLine

    try {
        return $jsonText | ConvertFrom-Json
    }
    catch {
        throw "Invalid JSON returned by DCS-SMS command: $($Arguments -join ' ')"
    }
}

function Get-InnerResult {
    param(
        [Parameter(Mandatory = $true)]
        $Response
    )

    if (-not $Response.ok) {
        throw "DCS-SMS request failed."
    }

    if ($null -eq $Response.return_value) {
        throw "DCS-SMS response contains no return_value."
    }

    if (-not $Response.return_value.ok) {
        throw "Mission Editor request failed."
    }

    return $Response.return_value
}

Write-Host ""
Write-Host "========================================="
Write-Host " Theater Command Mission Inspector"
Write-Host "========================================="
Write-Host ""

Write-Host "--- Runtime Status ----------------------"
& $dcsSms status

Write-Host ""
Write-Host "--- Mission Content Summary -------------"

try {
    $airbaseResult = Get-InnerResult (
        Invoke-DcsSmsJson -Arguments @("me", "airbase", "list")
    )

    $zoneResult = Get-InnerResult (
        Invoke-DcsSmsJson -Arguments @("me", "zone", "list")
    )

    $groupResult = Get-InnerResult (
        Invoke-DcsSmsJson -Arguments @("me", "group", "list")
    )

    $unitResult = Get-InnerResult (
        Invoke-DcsSmsJson -Arguments @("me", "unit", "list")
    )

    $triggerResult = Get-InnerResult (
        Invoke-DcsSmsJson -Arguments @("me", "trigger", "list")
    )

    $blueAirbases = @(
        $airbaseResult.airbases |
        Where-Object { $_.coalition -eq "blue" }
    )

    $redAirbases = @(
        $airbaseResult.airbases |
        Where-Object { $_.coalition -eq "red" }
    )

    $neutralAirbases = @(
        $airbaseResult.airbases |
        Where-Object { $_.coalition -eq "neutrals" }
    )

    $blueGroups = @(
        $groupResult.groups |
        Where-Object { $_.side -eq "blue" }
    )

    $redGroups = @(
        $groupResult.groups |
        Where-Object { $_.side -eq "red" }
    )

    $clientUnits = @(
        $unitResult.units |
        Where-Object { $_.skill -eq "Client" }
    )

    Write-Host ""
    Write-Host "Airbases:"
    Write-Host "  Total:    $($airbaseResult.count)"
    Write-Host "  Blue:     $($blueAirbases.Count)"
    Write-Host "  Red:      $($redAirbases.Count)"
    Write-Host "  Neutral:  $($neutralAirbases.Count)"

    Write-Host ""
    Write-Host "Mission objects:"
    Write-Host "  Zones:    $($zoneResult.count)"
    Write-Host "  Groups:   $($groupResult.count)"
    Write-Host "  Units:    $($unitResult.count)"
    Write-Host "  Triggers: $($triggerResult.count)"

    Write-Host ""
    Write-Host "Coalition groups:"
    Write-Host "  Blue:     $($blueGroups.Count)"
    Write-Host "  Red:      $($redGroups.Count)"

    Write-Host ""
    Write-Host "Client units:"
    Write-Host "  Count:    $($clientUnits.Count)"

    foreach ($unit in $clientUnits) {
        Write-Host "  - $($unit.name) [$($unit.type)]"
    }

    Write-Host ""
    Write-Host "Blue airbases:"

    foreach ($airbase in $blueAirbases) {
        Write-Host "  - $($airbase.name)"
    }

    Write-Host ""
    Write-Host "Mission triggers:"

    foreach ($trigger in $triggerResult.triggers) {
        Write-Host "  - $($trigger.name)"
    }

    Write-Host ""
    Write-Host "Inspection complete."
}
catch {
    Write-Host ""
    Write-Host "ERROR: Mission inspection failed."
    Write-Host $_.Exception.Message
    exit 1
}

Write-Host ""