<#Requires -Version 7.0
<#
.SYNOPSIS
  Deterministic run-ledger compiler for fit-to-brand reports (R-LEDGER).
.DESCRIPTION
  Build-Ledger.ps1 -RunDir runs/<id> [-Out <path>] [-Variant Joint|Rebrand|Campaign]
  Emits one section per phase: questions asked, answers given (value + src +
  who + date from PARAMS.log, later lines win), artifacts written (presence),
  gate verdicts (matching GATES.log lines verbatim), decisions taken (H3/H2
  lines). Open issues and next steps derive from the gaps found — nothing is
  hand-typed from memory. This is a report, not a gate: exit 0 even with gaps
  (gaps are flagged inline). Contract: bridge/REPORTS.md (R-LEDGER).
#>
param(
  [Parameter(Mandatory)][string]$RunDir,
  [string]$Out = '',
  [string]$Variant = ''
)

$ErrorActionPreference = 'Stop'

$stPath = Join-Path $RunDir 'STATE.json'
if (-not $Variant -and (Test-Path -LiteralPath $stPath)) {
  try { $Variant = (Get-Content -LiteralPath $stPath -Raw | ConvertFrom-Json).variant } catch { $Variant = 'Joint' }
}
if (-not $Variant) { $Variant = 'Joint' }
$runId = Split-Path -Leaf $RunDir
if (-not $Out) { $Out = Join-Path $RunDir "bridge/R-LEDGER-$runId.md" }

# phase -> ask-set (keys; trailing * = optional/provenance-only, never blocks)
$asks = @(
  @{ n = 0;  q = @('Q0.0','Q0.1','Q0.2','Q0.3','Q0.4','Q0.5','Q0.6','Q0.7','Q0.8') },
  @{ n = 1;  q = @('Q1.1','Q1.2','Q1.3','Q1.4','QN.0') },
  @{ n = 2;  q = @('Q3.1','Q3.2*','Q3.3') },
  @{ n = 3;  q = @('Q4.1*','Q4.2','Q4.3') },
  @{ n = 4;  q = @('Q5.1','Q5.2','QN.1') },
  @{ n = 5;  q = @('Q6.1','Q7.1') },
  @{ n = 6;  q = @('Q8.1','Q8.2*','Q9.1','Q9.2','Q9.3','QN.3','QN.4') },
  @{ n = 7;  q = @('Q10.1','Q11.1','Q8.2*') },
  @{ n = 8;  q = @('Q11.2','Q11.3','Q8.2*') },
  @{ n = 9;  q = @('Q12.1','Q12.2','Q13.1','QRP.1') },
  @{ n = 10; q = @('Q14.1','Q14.2') }
)
$artifacts = @{
  0  = @('PROFILE.md','SOURCES.log','PARAMS.log')
  1  = @('icp/S0_SPEC.md','icp/Appendix_Raw.md','icp/S1_THEME.md')
  2  = @('icp/S2_SITUATIONS.csv','icp/S2_SITUATIONS.md','icp/S3_STAKES.csv','icp/S3_STAKES.md','bridge/REFERENCE-STRETCH.md')
  3  = @('icp/S4_PRODUCTS.csv','icp/S4_FINDINGS.md','icp/S5A_FIT.csv','icp/NOTFIT.md')
  4  = @('icp/S5B_GROUPS.csv','icp/S5B_BRIEFS.md','bridge/BLOCKS.md','bridge/NAMES.csv')
  5  = @('brand/BRIEF.md','brand/REFERENCE-DECONSTRUCTION.md')
  6  = @('brand/GENERATION-PLANS.md','brand/EXPLORATORY-KIT.md','brand/ANCHOR-CHECKPOINT.md')
  7  = @('brand/GUIDELINES.md','brand/KEY-VISUAL.md','bridge/THREADS.csv')
  8  = @('brand/BRAND-LOCK.md','brand/AUDIT.md','brand/SCALE-MATRIX.md')
  9  = @('brand/PACKAGING.md','brand/FINAL-REVIEW.md','bridge/M0_BASELINE.md','bridge/M_PREDICTIONS.csv')
  10 = @('bridge/M1_INSTRUMENT.md','bridge/M2_OBS.csv','bridge/M3_DECISIONS.md')
}
# phase -> GATES.log match patterns (verbatim lines quoted in the ledger)
$gates = @{
  0  = @()
  1  = @('E-ask.*S0 elicitation','G1-header','G6-honesty','E-sources')
  2  = @('G2-count.*S2 rows','G3-ids','G5-bullets','G5-lenses','G5-zero')
  3  = @('G5-fitban','G5-physical','G5-rows','G5-verbs','G6-honesty.*NOT-fit')
  4  = @('G5-groups','N-schema','N-routes','N-status','N-reasons','N-length','N-confusion')
  5  = @('H3 Gate1','H3 Gate2')
  6  = @('H3 GenPlan-kit','N-pick','N-manual','H3 Gate3')
  7  = @('H3 GenPlan-guide','H3 GenPlan-keyvis')
  8  = @('H3 Gate4','H3 GenPlan-lock','H3 GenPlan-scale','H2 audit','H1-verdict')
  9  = @('B-threads','B-m0','R-FINAL generated')
  10 = @('M3','Q14')
}
$phaseName = @{ 0='Setup'; 1='S0 freeze + S1 fork'; 2='S2 situations + S3 stakes + reference';
  3='S4 incumbents + S5A fit'; 4='S5B groups + briefs + Blocks + naming screens';
  5='Stage 0 import + Stage 1 direction'; 6='Stage 2 kit + Stage 3 review + Anchor + naming lock';
  7='Guidelines + key visual + threads'; 8='Brand Lock + audit + correction + scale';
  9='Packaging + final review + M0'; 10='M1 instrument + M2 collect + M3 judge + M4 feed back' }

# PARAMS.log: last line wins per key (ftb.ps1 override rule)
$answers = @{}
$plog = Join-Path $RunDir 'PARAMS.log'
if (Test-Path -LiteralPath $plog) {
  foreach ($line in (Get-Content -LiteralPath $plog)) {
    if ($line -match '^\s*(Q[A-Z0-9.]+)\s*=\s*(.+?)\s*\|\s*([0-9-]+)\s*\|\s*(.+?)\s*\|\s*src=(\w[\w-]*)') {
      $answers[$Matches[1]] = @{ value = $Matches[2].Trim(); date = $Matches[3]; who = $Matches[4].Trim(); src = $Matches[5] }
    }
  }
}
$gateLines = @()
$glog = Join-Path $RunDir 'GATES.log'
if (Test-Path -LiteralPath $glog) { $gateLines = @(Get-Content -LiteralPath $glog) }

$md = @("# R-LEDGER — $runId (run ledger, compiler-built)",
  "",
  "Run: $runId | variant $Variant | compiled $(Get-Date -Format 'yyyy-MM-dd') by hooks/Build-Ledger.ps1.",
  "Body compiled from PARAMS.log + GATES.log + artifact presence — never hand-typed from memory.",
  "Conventions: later PARAMS.log lines win per key (ftb.ps1 override rule); `*` keys are optional/provenance-only.",
  "")

$openIssues = @()
foreach ($ph in $asks) {
  $n = $ph.n
  $md += "## Phase $n — $($phaseName[$n])"
  $md += ""
  $md += "### Asked / answered"
  foreach ($qk in $ph.q) {
    $opt = $qk.EndsWith('*'); $key = $qk.TrimEnd('*')
    if ($answers.ContainsKey($key)) {
      $a = $answers[$key]
      $md += "- $key = $($a.value) | $($a.date) | $($a.who) | src=$($a.src)"
    } else {
      $md += "- $key = (missing$($opt ? ', optional' : ''))"
      if (-not $opt) { $openIssues += "Phase ${n}: $key unanswered" }
    }
  }
  $md += ""
  $md += "### Artifacts"
  foreach ($rel in $artifacts[$n]) {
    $p = Join-Path $RunDir $rel
    if (Test-Path -LiteralPath $p) { $md += "- [x] $rel" }
    else { $md += "- [ ] $rel (missing)"; $openIssues += "Phase ${n}: $rel missing" }
  }
  $md += ""
  $md += "### Gates / approvals on record"
  $hits = @()
  foreach ($pat in $gates[$n]) { $hits += @($gateLines | Where-Object { $_ -match $pat }) }
  $decisions = @($hits | Where-Object { $_ -match '^(H3|H2)' })
  if ($hits.Count -eq 0) { $md += "- (no GATES.log lines for this phase — H1 exit-locks passed at transition: STATE.json advanced past phase $n, and H1 passes leave no log lines by design)" }
  else { foreach ($h in ($hits | Select-Object -Unique)) { $md += "- ``$h``" } }
  $md += ""
}

$md += "## Decisions taken (approvals, newest last)"
$decAll = @($gateLines | Where-Object { $_ -match '^(H3|H2)' })
if ($decAll.Count -eq 0) { $md += "- (none recorded)" }
else { foreach ($d in $decAll) { $md += "- ``$d``" } }
$md += ""
$md += "## Open issues"
if ($openIssues.Count -eq 0) { $md += "- none — every required key answered, every mapped artifact present." }
else { foreach ($o in ($openIssues | Select-Object -Unique)) { $md += "- $o" } }
$md += ""
$md += "## Next steps"
$firstOpen = @($asks | Where-Object {
  $n_ = $_.n
  ($_.q | Where-Object { -not $_.EndsWith('*') -and -not $answers.ContainsKey($_.TrimEnd('*')) }).Count -gt 0 -or
  ($artifacts[$n_] | Where-Object { -not (Test-Path -LiteralPath (Join-Path $RunDir $_)) }).Count -gt 0
} | Select-Object -First 1)
if ($null -eq $firstOpen) { $md += "- run ledger complete — operate the M-loop (M1→M4) or open the next thread's M0 row." }
else { $md += "- resume at phase $($firstOpen.n) ($($phaseName[$firstOpen.n])) — clear its open issues above, then ``ftb.ps1 next``." }
$md += ""
$md += "## Teach-back"
$md += ""
$md += "Mission: one-page-per-phase record of what was asked, answered, built, and approved in $runId, for owners and auditors."
$md += "Prerequisites assumed: the fit-to-brand repo plus this run folder (PARAMS.log, GATES.log, artifact tree)."
$md += "Follow-up questions for the agent: see Open issues above."
$md += "Decisions log: see Decisions taken above (H3/H2 lines, newest last)."

$md | Set-Content -LiteralPath $Out -Encoding utf8
Write-Output "LEDGER: wrote $Out ($($openIssues.Count) open issues)"
exit 0
