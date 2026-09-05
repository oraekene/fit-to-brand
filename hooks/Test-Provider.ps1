#Requires -Version 7.0
<#
.SYNOPSIS
  Provider health preflight for fit-to-brand Generation-Plan spend gates.
.DESCRIPTION
  Test-Provider.ps1 -RunDir runs/<id> -Provider <registry-id> [-Model <id>]
  Checks, in order: registry row exists (aliases resolve) -> key env presence
  (PASS/FAIL per name only; values and lengths never printed or logged) ->
  auth check GET {baseURL}{probe} (GET only, never a generation, never spends)
  -> model id exact match (live list, else row static defaults). Keyless rows
  get a reachability probe only; probe=none rows stop after the key check.
  Local-only hook (needs keys/secrets posture): never invoked by CI.
  Say/RESULT dialect matches hooks/Validate-Gates.ps1. Spec: bridge/PROVIDERS-SPEC.md §8.
#>
param(
  [Parameter(Mandatory)][string]$RunDir,
  [Parameter(Mandatory)][string]$Provider,
  [string]$Model = '',
  [int]$ProbeTimeoutSec = 15,
  [string]$Registry = ''
)

$ErrorActionPreference = 'Stop'
$script:fails = 0
$HooksDir = Split-Path -Parent $PSCommandPath
. (Join-Path $HooksDir 'Read-Registry.ps1')
if (-not $Registry) { $Registry = Join-Path (Split-Path -Parent $HooksDir) 'bridge/PROVIDERS.md' }
$runId = Split-Path -Leaf $RunDir

function Say($ok, $gate, $msg) {
  if ($ok) { Write-Output "PASS: [$gate] $msg" }
  else { Write-Output "FAIL: [$gate] $msg"; $script:fails++ }
}

$rows = Read-RegistryTable $Registry
if (@($rows).Count -eq 0) {
  Say $false 'P-registry' "no registry rows parsed from $Registry"
  Write-Output 'RESULT: RED (unreadable registry)'; exit 1
}
$row = Resolve-RegistryRow $rows $Provider
Say ($null -ne $row) 'P-row' ($null -ne $row ? "provider '$Provider' resolves to '$($row.id)' ($runId)" : "unknown provider '$Provider' ($runId)")
if ($null -eq $row) { Write-Output 'RESULT: RED (unknown provider)'; exit 1 }

$keyNames = @($row.keyEnv -split '[,;\s]+' | Where-Object { $_ -ne '' -and $_ -ne '—' -and $_ -ne 'none' -and $_ -notmatch '^\(.*\)$' })
if ($keyNames.Count -eq 0) {
  Write-Output "PASS: [P-key] keyless row '$($row.id)' (no secret required)"
} else {
  foreach ($kn in $keyNames) {
    $present = -not [string]::IsNullOrEmpty([System.Environment]::GetEnvironmentVariable($kn))
    Say $present 'P-key' ($present ? "env $kn is set" : "env $kn is missing (see REQUIREMENTS.md key table)")
  }
  if ($script:fails -gt 0) { Write-Output 'RESULT: RED (missing key)'; exit 1 }
}

if (Test-ProbeSkipped $row) {
  Write-Output "PASS: [P-auth] no probe for '$($row.id)' (key check only)"
} else {
  $keyless = ($keyNames.Count -eq 0)
  $headers = @{}
  if (-not $keyless) { $headers['Authorization'] = "Bearer $([System.Environment]::GetEnvironmentVariable($keyNames[0]))" }
  try {
    $resp = Invoke-RestMethod -Uri ($row.baseURL.TrimEnd('/') + $row.probe) -Headers $headers -TimeoutSec $ProbeTimeoutSec
    Say $true 'P-auth' "GET $($row.probe) 200 ($($row.id))"
  } catch {
    Say $false 'P-auth' "probe failed ($($row.id) $($row.probe): $($_.Exception.Message))"
  }
  if ($script:fails -gt 0) { Write-Output 'RESULT: RED (auth/probe failed)'; exit 1 }
}

if ($Model -ne '') {
  $hit = $false
  if (-not (Test-ProbeSkipped $row) -and $script:fails -eq 0) {
    try {
      $ids = @()
      if ($resp.PSObject.Properties.Name -contains 'data') { $ids = @($resp.data | ForEach-Object { $_.id }) }
      elseif ($resp.PSObject.Properties.Name -contains 'models') { $ids = @($resp.models | ForEach-Object { ($_.name -split ':')[0]; $_.name }) }
      if ($ids -ccontains $Model) { $hit = $true }
    } catch { $hit = $false }
  }
  if (-not $hit) {
    $tokens = @($row.defaults -split '[,;\s]+' | Where-Object { $_ -ne '' })
    if ($tokens -ccontains $Model) { $hit = $true }
  }
  Say $hit 'P-model' ($hit ? "model '$Model' known for '$($row.id)'" : "model '$Model' not found (live list + static defaults)")
  if ($script:fails -gt 0) { Write-Output 'RESULT: RED (unknown model)'; exit 1 }
}

Write-Output 'RESULT: GREEN (provider check pass; approvals may cite this run)'
exit 0

