<#Requires -Version 7.0
<#
.SYNOPSIS
  Tier-H1 deterministic gate validators for fit-to-brand runs.
.DESCRIPTION
  Pure functions over run artifacts (counts, IDs, registries, regex bans, presence).
  Exit 0 = all green; exit 1 = red (blocks the stage transition).
  Usage: ./hooks/Validate-Gates.ps1 -RunDir runs/<id> [-Stage ALL|S0|S2|S3|S4|S5A|S5B|BRAND|M]
  Conventions: see hooks/README.md (hook-layer file conventions).
#>
param(
  [Parameter(Mandatory)][string]$RunDir,
  [string]$Stage = 'ALL'
)

$ErrorActionPreference = 'Stop'
$script:fails = 0

function Say($ok, $gate, $msg) {
  if ($ok) { Write-Output "PASS: [$gate] $msg" }
  else { Write-Output "FAIL: [$gate] $msg"; $script:fails++ }
}

function Get-Csv($path) {
  if (!(Test-Path -LiteralPath $path)) { return $null }
  try { return Import-Csv -LiteralPath $path } catch { return @() }
}

function Has-Col($rows, $col) {
  if ($null -eq $rows -or @($rows).Count -eq 0) { return $false }
  return ($rows[0].PSObject.Properties.Name -contains $col)
}

$icp    = Join-Path $RunDir 'icp'
$bridge = Join-Path $RunDir 'bridge'
$log    = Join-Path $RunDir 'GATES.log'

function Stage-On($s) { return ($Stage -eq 'ALL') -or ($Stage -eq $s) }

# ---------- G1 header + G6 S0 honesty ----------
if (Stage-On 'S0') {
  $s0 = Join-Path $icp 'S0_SPEC.md'
  if (!(Test-Path -LiteralPath $s0)) { Say $false 'G1-header' "missing $s0" }
  else {
    $head = (Get-Content -LiteralPath $s0 -TotalCount 5) -join "`n"
    $need = @('project', 'run-mode', 'overlay', 'model', 'temp', 'date', 'spec-sha')
    $missing = @($need | Where-Object { $head -notmatch [regex]::Escape($_) })
    Say ($missing.Count -eq 0) 'G1-header' "header fields present$($missing.Count ? " (missing: $($missing -join ','))" : '')"
    $lines = Get-Content -LiteralPath $s0
    $oos = @($lines | Select-String -Pattern '(?i)^#+\s*(\d+\.\s*)?Out-of-Scope')
    $oosOk = $false
    if ($oos.Count -gt 0) {
      $rest = $lines[(($oos[0].LineNumber))..($lines.Count - 1)] | Where-Object { $_ -notmatch '^\s*#' -and $_.Trim() -ne '' }
      $oosOk = (@($rest).Count -gt 0)
    }
    Say $oosOk 'G6-honesty' 'Out-of-Scope section non-empty'
  }
}

# ---------- S2/S3: counts, IDs, bullets, lenses, $0 ----------
if (Stage-On 'S2' -or Stage-On 'S3') {
  $s2 = Get-Csv (Join-Path $icp 'S2_SITUATIONS.csv')
  $s3 = Get-Csv (Join-Path $icp 'S3_STAKES.csv')
  if ($null -eq $s2) { Say $false 'G2-count' 'missing S2_SITUATIONS.csv' }
  if ($null -eq $s3) { Say $false 'G2-count' 'missing S3_STAKES.csv' }
  if ($s2 -and $s3) {
    $n2 = @($s2).Count; $n3 = @($s3).Count
    Say ($n2 -eq $n3 -and $n2 -gt 0) 'G2-count' "S2 rows=$n2 S3 rows=$n3 (must match, >0)"
    $ids = @($s2 | ForEach-Object { $_.'S-ID' })
    Say (($ids | Where-Object { $_ -notmatch '^S-\d{4}$' }).Count -eq 0) 'G3-ids' 'all S-IDs match S-0001 shape'
    Say ($ids.Count -eq ($ids | Select-Object -Unique).Count) 'G3-ids' 'S-IDs unique'
    $s3ids = @($s3 | ForEach-Object { $_.'S-ID' })
    $dang = @($s3ids | Where-Object { $ids -notcontains $_ })
    Say ($dang.Count -eq 0) 'G3-ids' "no dangling S-IDs in S3$($dang.Count ? " ($($dang -join ','))" : '')"
    $badsec = @($s2 | Where-Object { $_.sector_tags -and (($_.sector_tags -split ';') | Where-Object { $_.Trim() -ne '' -and $_ -notmatch '^SEC-[A-Z]+$' }) })
    Say ($badsec.Count -eq 0) 'G3-ids' 'sector_tags empty or SEC-KEY shape (custom-key definitions → H2)'
    $nolens = @($s2 | Where-Object {
      -not ((($_.knowledge_need) -and ($_.knowledge_need -notmatch '^N/A')) -or
            (($_.decision_moment) -and ($_.decision_moment -notmatch '^N/A')) -or
            (($_.action_moment) -and ($_.action_moment -notmatch '^N/A'))) })
    Say ($nolens.Count -eq 0) 'G5-lenses' "every row ≥1 substantive lens (H1 presence; substance → H2)$($nolens.Count -gt 0 ? " ($($nolens.Count) rows)" : '')"
    $naNoReason = @($s2 | ForEach-Object { $_.knowledge_need; $_.decision_moment; $_.action_moment } |
      Where-Object { $_ -match '^N/A\s*$' })
    Say ($naNoReason.Count -eq 0) 'G5-lenses' 'bare N/A without reason absent'
    $md = Join-Path $icp 'S2_SITUATIONS.md'
    if (Test-Path -LiteralPath $md) {
      $bullets = (Get-Content -LiteralPath $md | Where-Object { $_ -match '^\s*[-*]\s+S-\d{4}\b' }).Count
      Say ($bullets -eq $n2) 'G5-bullets' "bulleted companion has $bullets bullets for $n2 S-IDs"
    } else { Say $false 'G5-bullets' 'missing S2_SITUATIONS.md' }
    $badzero = @($s3 | Where-Object {
      (($_.direct_ticket_typical_USD -match '^\$?0(\.0+)?$') -or ($_.failure_cost_max_USD -match '^\$?0(\.0+)?$')) -and
      -not (($_.priceless_flag) -and ($_.priceless_flag.Trim() -ne '')) -and
      -not (($_.price_note) -and ($_.price_note -match 'no_direct_ticket|priceless')) })
    Say ($badzero.Count -eq 0) 'G5-zero' "`$0 rows all flagged (priceless_flag or no_direct_ticket reason)"
  }
}

# ---------- S4: fit-ban, physical completeness, coverage ----------
if (Stage-On 'S4') {
  $s4 = Get-Csv (Join-Path $icp 'S4_PRODUCTS.csv')
  if ($null -eq $s4) { Say $false 'G2-count' 'missing S4_PRODUCTS.csv' }
  else {
    $raw = Get-Content -LiteralPath (Join-Path $icp 'S4_PRODUCTS.csv') -Raw
    Say ($raw -notmatch '\(a\)|\(b-[A-Z]+\)') 'G5-fitban' 'zero (a)/(b) tags in S4'
    $pids = @($s4 | ForEach-Object { $_.'P-ID' })
    Say (($pids | Where-Object { $_ -notmatch '^P-\d{4}$' }).Count -eq 0) 'G3-ids' 'all P-IDs match P-0001 shape'
    Say ($pids.Count -eq ($pids | Select-Object -Unique).Count) 'G3-ids' 'P-IDs unique'
    $chan = @('retail','dealer','distributor','direct','app-store','N/A')
    $incomplete = @($s4 | Where-Object {
      ($_.form -match 'physical|hybrid') -and
      (-not $_.unit_economics -or -not $_.channel -or -not $_.warranty_reg -or
       $_.unit_economics.Trim() -eq '' -or $_.channel.Trim() -eq '' -or $_.warranty_reg.Trim() -eq '' -or
       $chan -notcontains $_.channel.Trim()) })
    Say ($incomplete.Count -eq 0) 'G5-physical' 'physical/hybrid rows complete (unit_economics+channel+warranty_reg, channel in registry)'
    $s2 = Get-Csv (Join-Path $icp 'S2_SITUATIONS.csv')
    if ($s2) {
      $covered = @($s4 | ForEach-Object { ($_.'S-IDs_covered' -split '[;, ]') | Where-Object { $_ -match '^S-\d{4}$' } }) | Select-Object -Unique
      $all = @($s2 | ForEach-Object { $_.'S-ID' })
      $gap = @($all | Where-Object { $covered -notcontains $_ })
      Say ($gap.Count -eq 0) 'G2-count' "every S-ID ≥1 P-ID$($gap.Count ? " (uncovered: $($gap -join ','))" : '')"
    }
  }
}

# ---------- S5A: disposition, landing+cite, verb legality, NOT-fit ----------
if (Stage-On 'S5A') {
  $fit = Get-Csv (Join-Path $icp 'S5A_FIT.csv')
  $s4 = Get-Csv (Join-Path $icp 'S4_PRODUCTS.csv')
  if ($null -eq $fit) { Say $false 'G2-count' 'missing S5A_FIT.csv' }
  else {
    Say ((@($fit) | Where-Object { -not $_.landing_place -or -not $_.spec_module_cite }).Count -eq 0) 'G5-rows' 'every fit row has landing_place + spec cite (presence; specificity → H2)'
    if ($s4) {
      $pids = @($s4 | ForEach-Object { $_.'P-ID' })
      $fp = @($fit | ForEach-Object { $_.'P-ID' }) | Select-Object -Unique
      $gap = @($pids | Where-Object { $fp -notcontains $_ })
      Say ($gap.Count -eq 0) 'G2-count' "every P-ID dispositioned$($gap.Count ? " (missing: $($gap -join ','))" : '')"
      $dang = @($fp | Where-Object { $pids -notcontains $_ })
      Say ($dang.Count -eq 0) 'G3-ids' 'no dangling P-IDs in fit'
      $s2 = Get-Csv (Join-Path $icp 'S2_SITUATIONS.csv')
      if ($s2) {
        $sids = @($s2 | ForEach-Object { $_.'S-ID' })
        $fs = @($fit | ForEach-Object { $_.'S-ID' }) | Select-Object -Unique
        $sdang = @($fs | Where-Object { $sids -notcontains $_ })
        Say ($sdang.Count -eq 0) 'G3-ids' "no dangling S-IDs in fit$($sdang.Count ? " ($($sdang -join ','))" : '')"
      }
      $soft = @('b-ING','b-FACE','b-SRC')
      $forms = @{}; foreach ($r in $s4) { $forms[$r.'P-ID'] = $r.form }
      $badverb = @($fit | Where-Object { $soft -contains $_.verb -and $forms[$_.'P-ID'] -match '^physical$' })
      Say ($badverb.Count -eq 0) 'G5-verbs' 'no software-only verb on pure-physical P-ID'
    }
    $nf = Join-Path $icp 'NOTFIT.md'
    $nfOk = (Test-Path -LiteralPath $nf) -and ((Get-Content -LiteralPath $nf -Raw).Trim().Length -gt 0)
    Say $nfOk 'G6-honesty' 'NOT-fit non-empty or justified (NOTFIT.md)'
  }
}

# ---------- S5B: brief==group, registry ----------
if (Stage-On 'S5B') {
  $g = Get-Csv (Join-Path $icp 'S5B_GROUPS.csv')
  if ($null -eq $g -or -not (Has-Col $g 'GRP-ID')) { Say $false 'G5-groups' 'missing S5B_GROUPS.csv with GRP-ID column' }
  else {
    $nobrief = @($g | Where-Object { -not (Has-Col $g 'BRIEF') -or -not $_.BRIEF -or $_.BRIEF.Trim() -eq '' })
    Say ($nobrief.Count -eq 0) 'G5-groups' "brief count = group count ($(@($g).Count) groups)"
  }
}

# ---------- BRAND: approvals, audit verdict, modules, type record ----------
if (Stage-On 'BRAND') {
  $have = Test-Path -LiteralPath $log
  $lines = $have ? (Get-Content -LiteralPath $log) : @()
  foreach ($gate in @('Gate1','Gate2','Gate3','Gate4')) {
    Say (($lines -match "^H3 $gate APPROVED").Count -gt 0) 'H3-approval' "$gate approval token present in GATES.log"
  }
  Say (($lines -match '^H2 audit APPROVED').Count -gt 0 -or ($lines -match '^AUDIT APPROVED').Count -gt 0) 'H1-verdict' 'audit APPROVED token present before scale'
}

# ---------- M: thread coverage, M0 predictions, chain ----------
if (Stage-On 'M') {
  $t = Get-Csv (Join-Path $bridge 'THREADS.csv')
  $m = Get-Csv (Join-Path $bridge 'M_PREDICTIONS.csv')
  $g = Get-Csv (Join-Path $icp 'S5B_GROUPS.csv')
  if ($null -eq $t) { Say $false 'B-threads' 'missing bridge/THREADS.csv' }
  elseif ($g -and (Has-Col $g 'GRP-ID')) {
    $grps = @($g | ForEach-Object { $_.'GRP-ID' })
    $gap = @($grps | Where-Object { $gid = $_; @($t | Where-Object { $_.'GRP-ID' -eq $gid }).Count -eq 0 })
    Say ($gap.Count -eq 0) 'B-threads' "every group has a thread row or explicit unaddressed$($gap.Count ? " (missing: $($gap -join ','))" : '')"
  }
  if ($null -eq $m) { Say $false 'B-m0' 'missing bridge/M_PREDICTIONS.csv' }
  else {
    $nokill = @($m | Where-Object { -not $_.KILL_CONDITION -or -not $_.REPOSITION_CONDITION })
    Say ($nokill.Count -eq 0) 'B-m0' "every prediction has kill + reposition conditions ($(@($m).Count) rows)"
    if ($t) {
      $scaled = @($t | Where-Object { $_.STATUS -match 'scaled|flight|live' } | ForEach-Object { $_.'GRP-ID' })
      $mp = @($m | ForEach-Object { $_.'GRP-ID' })
      $gap = @($scaled | Where-Object { $mp -notcontains $_ } | Select-Object -Unique)
      Say ($gap.Count -eq 0) 'B-m0' "every scaled thread has an M0 row$($gap.Count ? " (missing: $($gap -join ','))" : '')"
    }
  }
}

# ---------- Elicitation: PARAMS.log required keys (ASK spine, bridge/QUESTIONNAIRES.md) ----------
$plog = Join-Path $RunDir 'PARAMS.log'
$answered = @()
if (Test-Path -LiteralPath $plog) {
  $answered = @(Get-Content -LiteralPath $plog | ForEach-Object {
    if ($_ -match '^\s*(Q[\d.]+)\s*=') { $Matches[1] } } | Select-Object -Unique)
}
function Need-Params($gate, $keys, $why) {
  $missing = @($keys | Where-Object { $answered -notcontains $_ })
  Say ($missing.Count -eq 0) $gate "$why$($missing.Count ? " (missing: $($missing -join ','))" : '')"
}
if (Stage-On 'S0')  { Need-Params 'E-ask' @('Q0.0','Q0.1','Q0.2','Q0.3','Q0.4','Q0.5','Q1.1','Q1.2','Q1.3','Q1.4') 'S0 elicitation complete (mode + profile + run-mode + overlay + quotas + claims seed)' }
if (Stage-On 'S5B') { Need-Params 'E-ask' @('Q5.1') 'grouping check asked before briefs lock' }
if (Stage-On 'BRAND') { Need-Params 'E-ask' @('Q10.1') 'guideline modules chosen by user' }
if (Stage-On 'M')   { Need-Params 'E-ask' @('Q13.1') 'kill/reposition thresholds accepted per thread' }

# ---------- naming (X-2: spaces and STEP0/STEP-0-style variant chaos, not case) ----------
$badnames = @(Get-ChildItem -LiteralPath $RunDir -Recurse -Force -File -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -match '\s' -or $_.Name -match 'STEP[-_ ]?0' } |
  Select-Object -ExpandProperty Name)
Say ($badnames.Count -eq 0) 'X2-naming' "file naming clean$($badnames.Count ? " ($($badnames -join ','))" : '')"

if ($script:fails -gt 0) { Write-Output "RESULT: RED ($($script:fails) failing checks)"; exit 1 }
Write-Output 'RESULT: GREEN (all H1 checks pass)'
exit 0
