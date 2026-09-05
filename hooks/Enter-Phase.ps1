<#Requires -Version 7.0
<#
.SYNOPSIS
  Deterministic phase-entry lock + ask emitter for fit-to-brand runs.
.DESCRIPTION
  Enter-Phase -RunDir runs/<id> -Phase N [-Variant Joint|Rebrand|Campaign]
  1. asserts every PARAMS.log key required to ENTER phase N (exit-keys of earlier
     phases, plus Q0.0 mode); 2. prints the exact Q-set to ask during phase N.
  Exit 0 = PROCEED (entry green + ask-list emitted); exit 1 = BLOCKED (missing keys
  listed — ask those first). Same inputs always produce the same ask-list and code.
  Companion to Validate-Gates.ps1 (exit-lock) — see hooks/README.md.
  Q-set wording: bridge/QUESTIONNAIRES.md. Answers: PARAMS.log + owning artifact.
#>
param(
  [Parameter(Mandatory)][string]$RunDir,
  [Parameter(Mandatory)][int]$Phase,
  [string]$Variant = 'Joint'
)

$ErrorActionPreference = 'Stop'

$prompts = @{
  'Q0.0'  = 'Run mode? phased (recommended) / batch-upfront / defaults.'
  'Q0.1'  = 'Image generator? Lovart-native (rec) / GPT-image / Midjourney+LLM / Firefly / SD-Comfy-local / Other.'
  'Q0.2'  = 'Video/motion generator? same-stack (rec) / Runway / Pika-Kling-Sora-Luma / None->storyboard.'
  'Q0.3'  = 'Layout/export finisher? Figma (rec) / Illustrator / Canva / code-SVG / None-conceptual-only.'
  'Q0.4'  = 'Font source? Google Fonts (rec) / Adobe (license?) / commercial foundry / system stack.'
  'Q0.5'  = 'Cost unit + cap? credits/tokens/API-$/render-min + number. No default — must answer.'
  'Q0.6'  = 'Subject form? digital (rec if repo/docs/site) / physical / hybrid / human-service. No default — 1 click.'
  'Q0.7'  = 'Context pack? accept 5-item pack (rec) / swap one / batch-upload all. Default accept-pack.'
  'Q0.8'  = 'Anything binding? none-known (rec) / cert-regime [name it] / regulated-claim [name it].'
  'Q1.1'  = 'Run-mode? single = full swap (rec for launches) / category = share-shift with wedge.'
  'Q1.2'  = 'Overlay? O-GTM (rec) / O-OPS / O-EDU / O-SUBSISTENCE / custom (+define registry).'
  'Q1.3'  = 'Quotas 300/50/10? accept (rec) / tighten / loosen (numbers).'
  'Q1.4'  = 'Claims seed? approved/prohibited/certs, or TBD (legal, stays flagged).'
  'Q3.1'  = 'Currency/year/PPP? USD+year (rec) / other / staple-equivalents.'
  'Q3.3'  = 'Reference? approve stretch-tested pick (rec) / supply another / describe direction.'
  'Q4.1'  = 'Wedge priority, top two? price / performance / distribution / compatibility. (category-mode)'
  'Q4.2'  = 'Cert regimes touching us? UL-CE-FDA-DOT / ROE-LOAC / curriculum / customary / none (TBD legal).'
  'Q4.3'  = 'What must we never claim? free text, or none-known.'
  'Q5.1'  = 'Grouping check? accept groups (rec) / add / merge / split (name them).'
  'Q5.2'  = 'Motion per group? accept proposed (rec) / correct per group.'
  'Q6.1'  = 'Import S5B + Block B + S0 claims verbatim? yes (rec) / adjust (returns as findings).'
  'Q7.1'  = 'Approve principles + prohibitions + direction? approve (rec) / adjust / reject.'
  'Q8.1'  = 'Font system A or B? A (rec, reasons stated) / B / neither.'
  'Q9.1'  = 'Agree KEEP/REMOVE/REFINE? accept (rec) / contest named items.'
  'Q9.2'  = 'REFINE vs RESTART recommendation? accept (rec) / override with triggers.'
  'Q9.3'  = 'Anchor approval? approve (rec) / refine / reject. Explicit confirm.'
  'Q10.1' = 'Guideline modules? multi-select, minimum pre-checked (rec).'
  'Q11.1' = 'SKU list confirmed? accept / amend.'
  'Q11.2' = 'Brand Lock roles confirmed? confirm (rec) / correct a role.'
  'Q11.3' = 'Formats + approved variables? accept matrix / amend.'
  'Q12.1' = 'Packaging views? accept six / amend.'
  'Q12.2' = 'Final review signoff? sign (rec) / hold named item.'
  'Q13.1' = 'Kill + reposition thresholds? accept motion defaults (rec) / adjust per thread.'
  'Q14.1' = 'M3 verdicts? accept table (rec) / override named PRED-ID with reason.'
  'Q14.2' = 'KILL-GROUP / launch-hold CONFIRM? explicit confirm, always. No default.'
  'QR.1'  = 'Equity sort per asset? must-keep / negotiable / must-drop. No default.'
  'QR.2'  = 'Per-group keep/kill/merge/split? accept proposed (rec) / change named groups.'
  'QR.3'  = 'Coexistence window? 8 weeks (rec) / other timing.'
  'QC.1'  = 'Which threads fly? multi-select, proven pre-checked (rec).'
  'QN.0'  = 'Working title? keep S0 project name PROVISIONAL (rec) / propose another.'
  'QN.1'  = 'Rank criteria? order tier-signal vs distinctiveness vs descriptiveness.'
  'QN.3'  = 'Pick from screened shortlist? choose one (rec with rank applied) / send back.'
  'QN.4'  = 'Manual checks done? confirm trademark + domain + handle (no default).'
  'QN-R.1' = 'Name: keep / evolve / replace? price name equity first.'
  'QRP.1' = 'Report brief? audience + depth skim/standard/deep (rec) + language.'
}

# phase -> exit-keys (joint numbering; rebrand adds QR keys; campaign has own order)
$joint = @(
  @{ n = 0;  keys = @('Q0.0','Q0.1','Q0.2','Q0.3','Q0.4','Q0.5','Q0.6','Q0.7','Q0.8'); extraRebrand = @('QR.1') },
  @{ n = 1;  keys = @('Q1.1','Q1.2','Q1.3','Q1.4'); extraRebrand = @() },
  @{ n = 2;  keys = @('Q3.1','Q3.3'); extraRebrand = @() },
  @{ n = 3;  keys = @('Q4.2','Q4.3'); extraRebrand = @() },
  @{ n = 4;  keys = @('Q5.1','Q5.2'); extraRebrand = @('QR.2') },
  @{ n = 5;  keys = @('Q6.1','Q7.1'); extraRebrand = @() },
  @{ n = 6;  keys = @('Q8.1','Q9.1','Q9.2','Q9.3'); extraRebrand = @() },
  @{ n = 7;  keys = @('Q10.1','Q11.1'); extraRebrand = @() },
  @{ n = 8;  keys = @('Q11.2','Q11.3'); extraRebrand = @() },
  @{ n = 9;  keys = @('Q12.1','Q12.2','Q13.1','QRP.1'); extraRebrand = @('QR.3') },
  @{ n = 10; keys = @('Q14.1'); extraRebrand = @() }
)
$campaign = @(
  @{ n = 1; keys = @('Q0.0','QC.1','Q13.1') },
  @{ n = 2; keys = @() },
  @{ n = 5; keys = @('Q14.1') }
)

if ($Variant -eq 'Campaign') { $table = $campaign } else { $table = $joint }
$order = @($table | ForEach-Object { $_.n })
if ($order -notcontains $Phase) { Write-Output "RESULT: BLOCKED (unknown phase $Phase for variant $Variant; order: $($order -join ','))"; exit 1 }

$plog = Join-Path $RunDir 'PARAMS.log'
$answers = @{}
if (Test-Path -LiteralPath $plog) {
  foreach ($line in (Get-Content -LiteralPath $plog)) {
    if ($line -match '^\s*(Q[A-Z0-9.]+)\s*=\s*(.+?)\s*(\||$)') { $answers[$Matches[1]] = $Matches[2].Trim() }
  }
}

function Test-NamingRequired($runDir) {
  $s0 = Join-Path $runDir 'icp/S0_SPEC.md'
  if (!(Test-Path -LiteralPath $s0)) { return $true }  # S0 unwritten: assume required, S0 gate decides
  $head = (Get-Content -LiteralPath $s0 -TotalCount 6) -join "`n"
  if ($head -match 'naming:\s*n/a\b') { return $false }
  return $true
}
$namingReq = Test-NamingRequired $RunDir

# entry requirement = exit-keys of all earlier phases (+Q4.1 iff category run; +QN.3 iff naming required)
$need = @()
foreach ($ph in $table) {
  if ($ph.n -ge $Phase) { break }
  $need += $ph.keys
  if ($Variant -eq 'Rebrand') { $need += $ph.extraRebrand }
}
if (($answers['Q1.1'] -eq 'category') -and ($Phase -gt 3)) { $need += @('Q4.1') }
if ($namingReq -and ($Variant -ne 'Campaign') -and ($Phase -gt 5)) { $need += @('QN.3') }
$need = @($need | Select-Object -Unique)
$missing = @($need | Where-Object { -not $answers.ContainsKey($_) })

Write-Output "ENTER-PHASE $Variant $Phase (mode: $($answers['Q0.0'] ? $answers['Q0.0'] : 'unset'))"
if ($missing.Count -gt 0) {
  Write-Output "ENTRY: BLOCKED — ask these first (prior-phase keys missing):"
  foreach ($q in $missing) { Write-Output "  ASK $q : $($prompts[$q])" }
  Write-Output "RESULT: BLOCKED ($($missing.Count) missing keys)"
  exit 1
}
Write-Output "ENTRY: PROCEED (all prior keys present)"

$here = @($table | Where-Object { $_.n -eq $Phase })
$ask = @($here[0].keys)
if ($Variant -eq 'Rebrand') { $ask += $here[0].extraRebrand }
if ($ask.Count -eq 0) {
  Write-Output "ASK NOW: none static this phase (per-generation Q8.2 / live Q14.2 still apply — see QUESTIONNAIRES.md)"
} else {
  Write-Output "ASK NOW (phase $Phase Q-set — <=3 per exchange, recommended first):"
  foreach ($q in $ask) { Write-Output "  ASK $q : $($prompts[$q])" }
}
Write-Output "RESULT: PROCEED"
exit 0
