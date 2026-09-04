<#Requires -Version 7.0
<#
.SYNOPSIS
  Tier-H1 deterministic name screens for fit-to-brand runs.
.DESCRIPTION
  Validate-Naming.ps1 -RunDir runs/<id> [-Stage screen|lock]
  screen: NAMES.csv exists with closed-enum columns; rejected rows carry reasons;
    length caps hold; shortlist+pick rows confusion-clean vs S4 examples corpus.
  lock: exactly one pick; pick confusion-clean; manual TM/domain/handle columns filled.
  Reads runs/<id>/icp/S0_SPEC.md for `naming: required|n/a`. Absent declaration =
  required; `n/a` or missing S0 = green skip (naming not in play for this run).
  Exit 0 = pass, 1 = red. Wired into ftb.ps1 phase-4 (screen) and phase-6 (lock) exits.
#>
param(
  [Parameter(Mandatory)][string]$RunDir,
  [string]$Stage = 'lock'
)

$ErrorActionPreference = 'Stop'
$script:fails = 0
$MaxWords = 4
$MaxChars = 32

function Say($ok, $gate, $msg) {
  if ($ok) { Write-Output "PASS: [$gate] $msg" }
  else { Write-Output "FAIL: [$gate] $msg"; $script:fails++ }
}

function Norm($s) { return (($s.ToLower() -replace '[^a-z0-9 ]', ' ') -replace '\s+', ' ').Trim() }
function Tokens($s) { return @(((Norm $s) -split ' ') | Where-Object { $_ -ne '' }) }

$icp = Join-Path $RunDir 'icp'
$bridge = Join-Path $RunDir 'bridge'
$s0 = Join-Path $icp 'S0_SPEC.md'
if (!(Test-Path -LiteralPath $s0)) { Write-Output 'PASS: [N-skip] no S0 yet — naming not in play'; exit 0 }
$head = (Get-Content -LiteralPath $s0 -TotalCount 6) -join "`n"
if ($head -match 'naming:\s*n/a\b') { Write-Output 'PASS: [N-skip] S0 declares naming n/a'; exit 0 }

$namesP = Join-Path $bridge 'NAMES.csv'
if (!(Test-Path -LiteralPath $namesP)) { Say $false 'N-names' 'missing bridge/NAMES.csv (naming required)'; exit 1 }
$names = Import-Csv -LiteralPath $namesP
$cols = @($names[0].PSObject.Properties.Name)
foreach ($c in @('CANDIDATE', 'ROUTE', 'TIER_READ', 'STATUS', 'REJECT_REASON', 'MANUAL_TM', 'MANUAL_DOMAIN', 'MANUAL_HANDLE')) {
  Say ($cols -contains $c) 'N-schema' "column $c present"
}
$routes = @('descriptive', 'evocative', 'coined', 'compound')
$stats = @('candidate', 'shortlist', 'pick', 'rejected')
$badroute = @($names | Where-Object { $routes -notcontains $_.ROUTE })
Say ($badroute.Count -eq 0) 'N-routes' 'routes from closed enum'
$badstat = @($names | Where-Object { $stats -notcontains $_.STATUS })
Say ($badstat.Count -eq 0) 'N-status' 'STATUSES from closed enum'
$noreason = @($names | Where-Object { $_.STATUS -eq 'rejected' -and -not $_.REJECT_REASON.Trim() })
Say ($noreason.Count -eq 0) 'N-reasons' 'every rejection carries REJECT_REASON'
$toolong = @($names | Where-Object { (@(Tokens $_.CANDIDATE)).Count -gt $MaxWords -or (Norm $_.CANDIDATE).Length -gt $MaxChars })
Say ($toolong.Count -eq 0) 'N-length' "candidates within caps ($MaxWords words / $MaxChars chars)"

# confusion corpus: S4 examples + category text (rebrand OLD names arrive via self-as-P-ID rows)
$corpus = @()
$s4P = Join-Path $icp 'S4_PRODUCTS.csv'
if (Test-Path -LiteralPath $s4P) {
  foreach ($r in (Import-Csv -LiteralPath $s4P)) { $corpus += (Norm "$($r.examples) $($r.category)") }
}
function Confused-With($cand) {
  $nc = Norm $cand
  if ($nc.Length -lt 4) { return $null }
  foreach ($c in $corpus) {
    if ($c -ne '' -and ($c.Contains($nc) -or $nc.Contains($c))) { return $c }
    foreach ($t in (Tokens $cand)) {
      if ($t.Length -ge 5 -and ((Tokens $c) -contains $t)) { return "$c (token $t)" }
    }
  }
  return $null
}

$screened = @($names | Where-Object { $_.STATUS -eq 'shortlist' -or $_.STATUS -eq 'pick' })
$confused = @()
foreach ($r in $screened) { $hit = Confused-With $r.CANDIDATE; if ($hit) { $confused += "$($r.CANDIDATE) ~ $hit" } }
Say ($confused.Count -eq 0) 'N-confusion' "shortlist+pick confusion-clean vs incumbents$($confused.Count ? " ($($confused -join '; '))" : '')"

if ($Stage -eq 'lock') {
  $picks = @($names | Where-Object { $_.STATUS -eq 'pick' })
  Say ($picks.Count -eq 1) 'N-pick' "exactly one pick$($picks.Count -ne 1 ? " (found $($picks.Count))" : " ($($picks[0].CANDIDATE))")"
  if ($picks.Count -eq 1) {
    $p = $picks[0]
    foreach ($c in @('MANUAL_TM', 'MANUAL_DOMAIN', 'MANUAL_HANDLE')) {
      Say ($p.$c -and $p.$c.Trim() -ne '') "N-manual" "pick $c confirmed ($($p.$c))"
    }
  }
}

if ($script:fails -gt 0) { Write-Output "RESULT: RED ($($script:fails) failing checks)"; exit 1 }
Write-Output 'RESULT: GREEN (all naming checks pass)'
exit 0
