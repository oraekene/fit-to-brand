<#Requires -Version 7.0
<#
.SYNOPSIS
  Runner-owned state machine for fit-to-brand runs — the single choke point for phase transitions.
.DESCRIPTION
  Phases advance ONLY through this script. The agent never self-declares a transition.
    ftb.ps1 init   -RunId <id> -Variant Joint|Rebrand|Campaign -Mode phased|batch|defaults
    ftb.ps1 next   [-RunId <id>]      # close current phase (exit-lock) + open next (entry-lock)
    ftb.ps1 ask    [-RunId <id>]      # reprint current phase ask-list
    ftb.ps1 status [-RunId <id>]      # STATE + current-phase entry check (read-only)
  -RunId defaults to $env:FTB_RUN when set. State lives in runs/<id>/STATE.json:
  {run, variant, mode, phase}. Exit 0 = advanced/proceed; exit 1 = blocked (reasons listed).
  Companions: Enter-Phase.ps1 (entry-lock + ask emitter), Validate-Gates.ps1 (exit-lock).
#>
param(
  [Parameter(Position = 0)][string]$Command = 'status',
  [string]$RunId = $env:FTB_RUN,
  [string]$Variant = 'Joint',
  [string]$Mode = 'phased',
  [switch]$Force
)

$ErrorActionPreference = 'Stop'
$HooksDir = Split-Path -Parent $PSCommandPath
$RepoRoot = Split-Path -Parent $HooksDir

function Repo-Pwsh($script, $ArgList) {
  $out = & pwsh -NoProfile -File (Join-Path $HooksDir $script) @ArgList 2>&1
  return @{ code = $LASTEXITCODE; out = @($out) -join "`n" }
}

function Read-State($id) {
  $p = Join-Path $RepoRoot "runs/$id/STATE.json"
  if (!(Test-Path -LiteralPath $p)) { return $null }
  return Get-Content -LiteralPath $p -Raw | ConvertFrom-Json
}

function Write-State($id, $st) {
  $d = Join-Path $RepoRoot "runs/$id"
  New-Item -ItemType Directory -Path $d -Force | Out-Null
  ($st | ConvertTo-Json) | Set-Content -LiteralPath (Join-Path $d 'STATE.json') -Encoding utf8
}

# joint/rebrand phase order 0..10; campaign order 1,2,5
function Phase-Order($variant) {
  if ($variant -eq 'Campaign') { return @(1, 2, 5) }
  return @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
}

# validator -Stage values checked when CLOSING each phase (joint numbering)
$exitStages = @{
  0 = @(); 1 = @('S0'); 2 = @('S2', 'S3'); 3 = @('S4', 'S5A'); 4 = @('S5B')
  5 = @(); 6 = @(); 7 = @(); 8 = @('BRAND'); 9 = @('M'); 10 = @()
}

switch ($Command) {
  'init' {
    if (-not $RunId) { Write-Output 'RESULT: BLOCKED (init needs -RunId)'; exit 1 }
    if ($Variant -notin @('Joint', 'Rebrand', 'Campaign')) { Write-Output "RESULT: BLOCKED (unknown variant $Variant)"; exit 1 }
    if ($Mode -notin @('phased', 'batch', 'defaults')) { Write-Output "RESULT: BLOCKED (unknown mode $Mode)"; exit 1 }
    $existing = Read-State $RunId
    if ($existing -and -not $Force) { Write-Output "RESULT: BLOCKED (run $RunId already initialized; use -Force to reset)"; exit 1 }
    foreach ($sub in @('icp', 'brand', 'bridge')) { New-Item -ItemType Directory -Path (Join-Path $RepoRoot "runs/$RunId/$sub") -Force | Out-Null }
    $first = (Phase-Order $Variant)[0]
    Write-State $RunId @{ run = $RunId; variant = $Variant; mode = $Mode; phase = $first }
    Add-Content -LiteralPath (Join-Path $RepoRoot "runs/$RunId/PARAMS.log") -Value "Q0.0 = $Mode | $(Get-Date -Format 'yyyy-MM-dd') | runner-init | src=asked" -Encoding utf8
    Write-Output "INIT: run $RunId ($Variant, $Mode) opened at phase $first"
    $r = Repo-Pwsh 'Enter-Phase.ps1' @('-RunDir', (Join-Path $RepoRoot "runs/$RunId"), '-Phase', $first, '-Variant', $Variant)
    $r.out | Write-Output
    exit $r.code
  }
  'ask' {
    if (-not $RunId) { Write-Output 'RESULT: BLOCKED (need -RunId or $env:FTB_RUN)'; exit 1 }
    $st = Read-State $RunId
    if (-not $st) { Write-Output "RESULT: BLOCKED (run $RunId not initialized; ftb.ps1 init first)"; exit 1 }
    $r = Repo-Pwsh 'Enter-Phase.ps1' @('-RunDir', (Join-Path $RepoRoot "runs/$RunId"), '-Phase', $st.phase, '-Variant', $st.variant)
    $r.out | Write-Output
    exit $r.code
  }
  'status' {
    if (-not $RunId) { Write-Output 'RESULT: BLOCKED (need -RunId or $env:FTB_RUN)'; exit 1 }
    $st = Read-State $RunId
    if (-not $st) { Write-Output "RESULT: BLOCKED (run $RunId not initialized; ftb.ps1 init first)"; exit 1 }
    Write-Output "STATUS: run $($st.run) variant $($st.variant) mode $($st.mode) phase $($st.phase)"
    $r = Repo-Pwsh 'Enter-Phase.ps1' @('-RunDir', (Join-Path $RepoRoot "runs/$RunId"), '-Phase', $st.phase, '-Variant', $st.variant)
    $r.out | Write-Output
    exit 0
  }
  'next' {
    if (-not $RunId) { Write-Output 'RESULT: BLOCKED (need -RunId or $env:FTB_RUN)'; exit 1 }
    $st = Read-State $RunId
    if (-not $st) { Write-Output "RESULT: BLOCKED (run $RunId not initialized; ftb.ps1 init first)"; exit 1 }
    $order = Phase-Order $st.variant
    $idx = [array]::IndexOf($order, [int]$st.phase)
    if ($idx -lt 0) { Write-Output "RESULT: BLOCKED (STATE phase $($st.phase) not in $($st.variant) order)"; exit 1 }
    $runDir = Join-Path $RepoRoot "runs/$RunId"
    # 1. exit-lock: validator stages mapped to the closing phase
    foreach ($vs in $exitStages[[int]$st.phase]) {
      $r = Repo-Pwsh 'Validate-Gates.ps1' @('-RunDir', $runDir, '-Stage', $vs)
      if ($r.code -ne 0) {
        Write-Output "EXIT-LOCK: phase $($st.phase) cannot close (Validate-Gates -Stage $vs RED):"
        ($r.out -split "`n" | Where-Object { $_ -match '^FAIL' }) | Write-Output
        Write-Output "RESULT: BLOCKED (fix the stage, re-run downstream, then ftb.ps1 next)"
        exit 1
      }
    }
    # 2. last phase? run is complete
    if ($idx -eq $order.Count - 1) {
      Write-Output "COMPLETE: run $RunId closed phase $($st.phase) — all phases done. See M4/deprecation close-outs."
      exit 0
    }
    # 3. entry-lock for the next phase (also emits its ask-list)
    $nx = $order[$idx + 1]
    $r = Repo-Pwsh 'Enter-Phase.ps1' @('-RunDir', $runDir, '-Phase', $nx, '-Variant', $st.variant)
    if ($r.code -ne 0) {
      Write-Output "ENTRY-LOCK: phase $nx cannot open (missing prior answers):"
      $r.out | Write-Output
      Write-Output "RESULT: BLOCKED (answer via QUESTIONNAIRES.md Q-sets, record in PARAMS.log, retry)"
      exit 1
    }
    $st.phase = $nx
    Write-State $RunId $st
    Write-Output "ADVANCED: run $RunId now in phase $nx"
    $r.out | Write-Output
    exit 0
  }
  default { Write-Output "RESULT: BLOCKED (unknown command $Command; want init|next|ask|status)"; exit 1 }
}
