<#Requires -Version 7.0
<#
.SYNOPSIS
  Runner-owned state machine for fit-to-brand runs — the single choke point for phase transitions.
.DESCRIPTION
  Phases advance ONLY through this script. The agent never self-declares a transition.
    ftb.ps1 init   -RunId <id> -Variant Joint|Rebrand|Campaign -Mode phased|batch|defaults [-Preset <name> | -Provider <id> [-Model <m>] [-VideoProvider <v>] [-VideoModel <vm>]]
    ftb.ps1 quickstart -RunId <id> -Variant Joint|Rebrand|Campaign (-Preset <name> | -Provider <id> [-Model <m>]) -Form digital|physical|hybrid|human-service [-Subject "<brief>"]
    ftb.ps1 run    [-RunId <id>] [-MaxSteps <n>]   # auto-next until BLOCKED or COMPLETE
    ftb.ps1 next   [-RunId <id>]      # close current phase (exit-lock) + open next (entry-lock)
    ftb.ps1 ask    [-RunId <id>]      # reprint current phase ask-list
    ftb.ps1 status [-RunId <id>]      # STATE + current-phase entry check (read-only)
  -RunId defaults to $env:FTB_RUN when set. State lives in runs/<id>/STATE.json:
  {run, variant, mode, phase}. Exit 0 = advanced/proceed; exit 1 = blocked (reasons listed).
  quickstart = init in defaults mode + preset Q0.1-Q0.5 (src=asked, choosing a preset
  IS answering) + -Form as Q0.6 (src=asked: form has no default per
  bridge/QUESTIONNAIRES.md Q0.6, the flag is the 1 click) + Q0.7 accept-pack and
  Q0.8 none-known plus R1/R2 doc defaults (src=default) + PROFILE.md + SOURCES.log
  template. Deferred and
  artifact-dependent keys (Q2.1, Q3.3, Q5.x, Q6.1, Q7.1, Q8.x, Q9.x, Q11.x, Q12.x,
  Q14.1) are NOT seeded: they get their short confirm at phase, then run again.
  Never defaulted, never seeded: QR.1 (rebrand equity), Q14.2 (kill/launch-hold),
  QN.4 (trademark/domain/handle). Preset table mirrors bridge/PROFILES.md.
  Companions: Enter-Phase.ps1 (entry-lock + ask emitter), Validate-Gates.ps1 (exit-lock).
#>
param(
  [Parameter(Position = 0)][string]$Command = 'status',
  [string]$RunId = $env:FTB_RUN,
  [string]$Variant = 'Joint',
  [string]$Mode = 'phased',
  [string]$Preset = '',
  [string]$Provider = '',
  [string]$Model = '',
  [string]$VideoProvider = '',
  [string]$VideoModel = '',
  [string]$Subject = '',
  [string]$Form = '',
  [int]$MaxSteps = 12,
  [switch]$Force
)

$ErrorActionPreference = 'Stop'
$HooksDir = Split-Path -Parent $PSCommandPath
$RepoRoot = Split-Path -Parent $HooksDir

# Preset table: preset -> Q0.1..Q0.5 values + PROFILE.md lines. Mirrors bridge/PROFILES.md.
$presets = @{
  'lovart' = @{ q = @('Lovart-native', 'same-stack', 'Figma', 'Google Fonts', 'credits cap 400');
    lines = @('Image generator: Lovart-native (Thinking Mode recommended)',
      'Video/motion generator: same-stack as image',
      'Layout/export finisher: Figma (owns text defects)',
      'Font source: Google Fonts (Approved Font Source)',
      'Cost unit + cap: credits cap 400',
      'Capability flags: reference-image yes; multi-reference yes; aspect-ratio yes; text-in-image partial; motion yes; vector-export no',
      'Fallbacks agreed: finish all type in Figma; packaging stays conceptual-only') }
  'gpt' = @{ q = @('GPT-image-class', 'Sora', 'Figma', 'Google Fonts', 'seat-time cap 300');
    lines = @('Image generator: GPT-image-class (direction here, render there; handoff in plan)',
      'Video/motion generator: Sora, from the approved still only',
      'Layout/export finisher: Figma (owns text defects; small type always re-set here)',
      'Font source: Google Fonts (Approved Font Source)',
      'Cost unit + cap: seat-time cap 300',
      'Capability flags: reference-image yes; aspect-ratio yes; text-in-image good-but-comp-only; motion via Sora; vector-export no',
      'Fallbacks agreed: model type is placement comp only; shipped type is Figma-set; packaging conceptual-only') }
  'api' = @{ q = @('GPT-image-class', 'Runway', 'Figma', 'Google Fonts', 'API-$ cap 30');
    lines = @('Image generator: GPT-image-class via API (agent assembles payloads)',
      'Video/motion generator: Runway via API, from the approved still only',
      'Layout/export finisher: Figma (owns text defects)',
      'Font source: Google Fonts (Approved Font Source)',
      'Cost unit + cap: API-$ cap 30',
      'Capability flags: reference-image yes; aspect-ratio yes; text-in-image good-but-comp-only; motion via Runway; vector-export no',
      'Fallbacks agreed: keys live in shell env / agent tool config, never in this run; shipped type is Figma-set') }
  'midjourney' = @{ q = @('Midjourney + LLM direction', 'None storyboard-fallback', 'Figma', 'Google Fonts', 'seat-time cap 300');
    lines = @('Image generator: Midjourney + LLM direction (image via Discord/web, direction via LLM)',
      'Video/motion generator: None -> storyboard + shot-list + motion-direction spec (upgrade via Q0.2 swap-in)',
      'Layout/export finisher: Figma — MJ renders scene/composition ONLY; all type is native Figma layers',
      'Font source: Google Fonts (Approved Font Source)',
      'Cost unit + cap: seat-time cap 300',
      'Capability flags: reference-image partial; aspect-ratio yes; text-in-image no; motion no; vector-export no',
      'Fallbacks agreed: placeholder glyph bars where type goes; no exact fonts or 16:9 doc slides from MJ') }
  'firefly' = @{ q = @('Adobe Firefly', 'None storyboard-fallback', 'Illustrator', 'Adobe Fonts license-confirmed', 'credits cap 500');
    lines = @('Image generator: Adobe Firefly (commercially-safe training; Content Credentials on)',
      'Video/motion generator: None -> storyboard + shot-list + motion-direction spec (upgrade via Q0.2 swap-in)',
      'Layout/export finisher: Illustrator / Photoshop (type via app layers)',
      'Font source: Adobe Fonts, license confirmed (Approved Font Source)',
      'Cost unit + cap: credits cap 500',
      'Capability flags: reference-image yes; aspect-ratio yes; text-in-image partial; motion no; vector-export partial',
      'Fallbacks agreed: small type re-set in app; packaging stays conceptual-only (Rule 12)') }
  'local' = @{ q = @('SD-Comfy-local', 'None storyboard-fallback', 'Figma', 'Google Fonts', 'render-minutes cap 120');
    lines = @('Image generator: SD-Comfy-local (record the endpoint URL in this line, e.g. @ 127.0.0.1:8181 — URLs are not secrets)',
      'Video/motion generator: None -> storyboard + shot-list + motion-direction spec (upgrade via Q0.2 swap-in)',
      'Layout/export finisher: Figma (owns text defects)',
      'Font source: Google Fonts (Approved Font Source)',
      'Cost unit + cap: render-minutes cap 120',
      'Capability flags: reference-image yes; aspect-ratio yes; text-in-image no; motion no; vector-export no',
      'Fallbacks agreed: scene pass only; lock prohibitions double as negative prompts; all type in Figma') }
  'figma' = @{ q = @('Figma-embedded', 'None storyboard-fallback', 'Figma', 'Google Fonts', 'seat-time cap 300');
    lines = @('Image generator: Figma-embedded (scene zone only, under lock roles)',
      'Video/motion generator: None -> storyboard + shot-list + motion-direction spec (upgrade via Q0.2 swap-in)',
      'Layout/export finisher: Figma — zones, rail, chip, type all native layers; no separate finish step',
      'Font source: Google Fonts (Approved Font Source)',
      'Cost unit + cap: seat-time cap 300',
      'Capability flags: reference-image n/a; aspect-ratio native frames; text-in-image native; motion no; vector-export partial',
      'Fallbacks agreed: flat doc screenshots where generation falls short; packaging conceptual-only') }
  'docs' = @{ q = @('None conceptual-only', 'None storyboard-fallback', 'None conceptual-only', 'Google Fonts', 'seat-time cap 120');
    lines = @('Image generator: None — written specs + ASCII wireframes (zero render spend)',
      'Video/motion generator: None -> storyboard + shot-list + motion-direction spec',
      'Layout/export finisher: None — Markdown + ASCII in-repo; type as named font specs, not pixels',
      'Font source: Google Fonts (Approved Font Source)',
      'Cost unit + cap: seat-time cap 120',
      'Capability flags: reference-image no; aspect-ratio n/a; text-in-image no; motion no; vector-export no',
      'Fallbacks agreed: every visual deliverable as a written spec; 16:9 slides as structured Markdown') }
}

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

function Seed-Answer($runDir, $q, $value, $who, $src) {
  $date = Get-Date -Format 'yyyy-MM-dd'
  Add-Content -LiteralPath (Join-Path $runDir 'PARAMS.log') -Value "$q = $value | $date | $who | src=$src" -Encoding utf8
}

function Write-ProfileFile($runDir, $name, $p) {
  $date = Get-Date -Format 'yyyy-MM-dd'
  $body = @("# Provider Profile — preset $name (declared $date)") + $p.lines + @(
    '',
    'Outside-the-repo half: logins, API keys, and licenses live in your platform account,',
    'shell env, or agent tool config — never in this run. Local endpoints: record the URL',
    'in the image line above.',
    'Override: append a PARAMS.log line (later lines win for entry locks), update this',
    'file, and re-issue pending Generation Plans (see bridge/CAMPAIGN-EXPANSION-ORCHESTRATION.md:105).')
  Set-Content -LiteralPath (Join-Path $runDir 'PROFILE.md') -Value $body -Encoding utf8
}

$packChecklists = @{
  'digital' = @('# [ ] repo/README (F1)', '# [ ] docs/wiki (F3)', '# [ ] site + pricing (F2)', '# [ ] 1 user-voice: tickets OR chat OR calls (F4)', '# [ ] claims/certs if any (F3/F5)')
  'physical' = @('# [ ] BOM/datasheet (F1)', '# [ ] manual/warranty (F3)', '# [ ] catalog/price sheet (F2)', '# [ ] 1 field-voice: reviews OR RMAs (F4)', '# [ ] cert regime if any (F5)')
  'hybrid' = @('# [ ] digital pack: repo/README (F1) + docs/wiki (F3) + site+pricing (F2) + 1 user-voice (F4)', '# [ ] BOM/manual (F1/F3)')
  'human-service' = @('# [ ] SOP/menu/rate card (F3)', '# [ ] 1 contract/SOW (F3/F5)', '# [ ] 1 voice: tickets/calls/reviews (F4)', '# [ ] staffing/training iff delivery gap (F3)')
}

function Write-SourcesTemplate($runDir, $form) {
  $body = @('# SOURCES.log — Q0.7 context-pack manifest (schema: bridge/QUESTIONNAIRES.md Q0.7).',
    '# One line per source: S<nn> = <label> | <family F1-F6> | <path-or-url> | <sha256-or-n/a> | <yyyy-mm-dd> | <who> | src=<asked|dropped|batch|default>',
    '# Families: F1 what-it-is, F2 what-you-promise, F3 what-you-agreed, F4 what-users-say, F5 what-binds-you, F6 category-market.',
    "# Minimum 1 line; recommended 5 (the accepted $form-single pack below). S0 spec-sha MUST resolve here or the S0 exit-lock goes red.",
    "# Pack checklist ($form-single, accept-pack — tick by appending S<nn> lines):") + $packChecklists[$form] + @(
    '# Drop a source = append one S<nn> line. H1 reads only the S<nn> = head, so comments never break hooks.')
  Set-Content -LiteralPath (Join-Path $runDir 'SOURCES.log') -Value $body -Encoding utf8
}

. (Join-Path (Split-Path -Parent $PSCommandPath) 'Read-Registry.ps1')

function Get-ProviderRow($id) {
  # canonical registry row for an id/alias, or $null (bridge/PROVIDERS.md is single source)
  return Resolve-RegistryRow (Get-RegistryRows $RepoRoot) $id
}

function Assert-ProviderFlags($Provider, $Model, $VideoProvider, $VideoModel) {
  # returns $null when flags are coherent, else the BLOCKED reason (single
  # return value by design: Write-Output here would pollute the return and
  # defeat the caller's -not check).
  if ($Preset -and $Provider) { return 'one toolchain source per run: -Preset or -Provider, not both' }
  if (($Model -or $VideoProvider -or $VideoModel) -and -not $Provider) { return '-Model/-VideoProvider/-VideoModel need -Provider' }
  foreach ($pair in @(@('provider', $Provider), @('video provider', $VideoProvider))) {
    if ($pair[1] -and -not (Get-ProviderRow $pair[1])) { return "unknown $($pair[0]) $($pair[1]); see bridge/PROVIDERS.md" }
  }
  return $null
}

function Write-ProviderProfile($runDir, $row, $model, $vrow, $vmodel) {
  $date = Get-Date -Format 'yyyy-MM-dd'
  $vline = ($vrow ? "video $($vmodel ? $vmodel : '(Q0.2m at phase 0)')" : 'same-stack (Q0.1 provider+model drive motion)')
  $body = @("# Provider Profile — registry $($row.id) (declared $date)",
    "Provider: $($row.id) ($($row.baseURL))",
    "Models: image $($model ? $model : '(Q0.1m at phase 0)') / $vline",
    "Key: $($row.keyEnv) in env (value never recorded)",
    "Endpoint shapes: images $($row.images); video $($row.video) (see bridge/PROVIDERS.md)",
    'Fallbacks agreed: web-manual path via bridge/PROFILES.md presets when the provider is unavailable; packaging stays conceptual-only',
    '',
    'Outside-the-repo half: logins, API keys, and licenses live in your platform account,',
    'shell env, or agent tool config — never in this run. Local endpoints: record the URL',
    'in the provider row above (custom) — keys never.',
    'Override: append a PARAMS.log line (later lines win for entry locks), update this',
    'file, and re-issue pending Generation Plans (see bridge/CAMPAIGN-EXPANSION-ORCHESTRATION.md:105).')
  Set-Content -LiteralPath (Join-Path $runDir 'PROFILE.md') -Value $body -Encoding utf8
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
# naming screens when CLOSING these phases (self-skips green when S0 says n/a)
$namingStages = @{ 4 = @('screen'); 6 = @('lock') }

switch ($Command) {
  'init' {
    if (-not $RunId) { Write-Output 'RESULT: BLOCKED (init needs -RunId)'; exit 1 }
    if ($Variant -notin @('Joint', 'Rebrand', 'Campaign')) { Write-Output "RESULT: BLOCKED (unknown variant $Variant)"; exit 1 }
    if ($Mode -notin @('phased', 'batch', 'defaults')) { Write-Output "RESULT: BLOCKED (unknown mode $Mode)"; exit 1 }
    if ($Preset -and -not $presets.ContainsKey($Preset)) { Write-Output "RESULT: BLOCKED (unknown preset $Preset; valid: $($presets.Keys -join ', '))"; exit 1 }
    $whyProv = Assert-ProviderFlags $Provider $Model $VideoProvider $VideoModel; if ($whyProv) { Write-Output "RESULT: BLOCKED ($whyProv)"; exit 1 }
    $prow = Get-ProviderRow $Provider
    $vrow = Get-ProviderRow $VideoProvider
    $existing = Read-State $RunId
    if ($existing -and -not $Force) { Write-Output "RESULT: BLOCKED (run $RunId already initialized; use -Force to reset)"; exit 1 }
    foreach ($sub in @('icp', 'brand', 'bridge')) { New-Item -ItemType Directory -Path (Join-Path $RepoRoot "runs/$RunId/$sub") -Force | Out-Null }
    $first = (Phase-Order $Variant)[0]
    Write-State $RunId @{ run = $RunId; variant = $Variant; mode = $Mode; phase = $first }
    Add-Content -LiteralPath (Join-Path $RepoRoot "runs/$RunId/PARAMS.log") -Value "Q0.0 = $Mode | $(Get-Date -Format 'yyyy-MM-dd') | runner-init | src=asked" -Encoding utf8
    if ($Preset) {
      $runDir = Join-Path $RepoRoot "runs/$RunId"
      $p = $presets[$Preset]
      for ($i = 0; $i -lt 5; $i++) { Seed-Answer $runDir "Q0.$($i + 1)" $p.q[$i] 'runner-init' 'asked' }
      Write-ProfileFile $runDir $Preset $p
      Write-Output "PRESET: $Preset seeded (Q0.1-Q0.5, src=asked) + PROFILE.md written"
    }
    if ($prow) {
      $runDir = Join-Path $RepoRoot "runs/$RunId"
      Seed-Answer $runDir 'Q0.1' $prow.id 'runner-init' 'asked'
      if ($Model) { Seed-Answer $runDir 'Q0.1m' $Model 'runner-init' 'asked' }
      Seed-Answer $runDir 'Q0.2' ($vrow ? $vrow.id : 'same-stack') 'runner-init' 'asked'
      if ($vrow -and $VideoModel) { Seed-Answer $runDir 'Q0.2m' $VideoModel 'runner-init' 'asked' }
      Write-ProviderProfile $runDir $prow $Model $vrow $VideoModel
      Write-Output "PROVIDER: $($prow.id) seeded (Q0.1$($Model ? '+Q0.1m' : '') + Q0.2, src=asked) + PROFILE.md written"
    }
    Write-Output "INIT: run $RunId ($Variant, $Mode) opened at phase $first"
    $r = Repo-Pwsh 'Enter-Phase.ps1' @('-RunDir', (Join-Path $RepoRoot "runs/$RunId"), '-Phase', $first, '-Variant', $Variant)
    $r.out | Write-Output
    exit $r.code
  }
  'quickstart' {
    if (-not $RunId) { Write-Output 'RESULT: BLOCKED (quickstart needs -RunId)'; exit 1 }
    if ($Variant -notin @('Joint', 'Rebrand', 'Campaign')) { Write-Output "RESULT: BLOCKED (unknown variant $Variant)"; exit 1 }
    if (-not $Preset -and -not $Provider) { Write-Output "RESULT: BLOCKED (quickstart needs -Preset <name>; valid: $($presets.Keys -join ', '); or -Provider <id> (see bridge/PROVIDERS.md); or use init for manual setup)"; exit 1 }
    if ($Preset -and -not $presets.ContainsKey($Preset)) { Write-Output "RESULT: BLOCKED (unknown preset $Preset; valid: $($presets.Keys -join ', '))"; exit 1 }
    $whyProv = Assert-ProviderFlags $Provider $Model $VideoProvider $VideoModel; if ($whyProv) { Write-Output "RESULT: BLOCKED ($whyProv)"; exit 1 }
    $qprow = Get-ProviderRow $Provider
    $qvrow = Get-ProviderRow $VideoProvider
    $forms = @('digital', 'physical', 'hybrid', 'human-service')
    if (-not $Form) { Write-Output "RESULT: BLOCKED (quickstart needs -Form <form>; valid: $($forms -join ', '); form has no default — the flag is the 1 click, see bridge/QUESTIONNAIRES.md Q0.6)"; exit 1 }
    if ($forms -notcontains $Form) { Write-Output "RESULT: BLOCKED (unknown form $Form; valid: $($forms -join ', '))"; exit 1 }
    $existing = Read-State $RunId
    if ($existing -and -not $Force) { Write-Output "RESULT: BLOCKED (run $RunId already initialized; use -Force to reset)"; exit 1 }
    foreach ($sub in @('icp', 'brand', 'bridge')) { New-Item -ItemType Directory -Path (Join-Path $RepoRoot "runs/$RunId/$sub") -Force | Out-Null }
    $first = (Phase-Order $Variant)[0]
    Write-State $RunId @{ run = $RunId; variant = $Variant; mode = 'defaults'; phase = $first }
    $runDir = Join-Path $RepoRoot "runs/$RunId"
    Seed-Answer $runDir 'Q0.0' 'defaults' 'quickstart' 'asked'
    if ($Preset) {
      $p = $presets[$Preset]
      for ($i = 0; $i -lt 5; $i++) { Seed-Answer $runDir "Q0.$($i + 1)" $p.q[$i] 'quickstart' 'asked' }
      Write-ProfileFile $runDir $Preset $p
    } else {
      Seed-Answer $runDir 'Q0.1' $qprow.id 'quickstart' 'asked'
      if ($Model) { Seed-Answer $runDir 'Q0.1m' $Model 'quickstart' 'asked' }
      Seed-Answer $runDir 'Q0.2' ($qvrow ? $qvrow.id : 'same-stack') 'quickstart' 'asked'
      if ($qvrow -and $VideoModel) { Seed-Answer $runDir 'Q0.2m' $VideoModel 'quickstart' 'asked' }
      Write-ProviderProfile $runDir $qprow $Model $qvrow $VideoModel
    }
    $title = ($Subject ? $Subject : $RunId) -replace '\|', '/'
    $year = (Get-Date).Year
    Seed-Answer $runDir 'Q1.1' 'single' 'quickstart' 'default'
    Seed-Answer $runDir 'Q0.6' $Form 'quickstart' 'asked'
    Seed-Answer $runDir 'Q0.7' 'accept-pack 5-item' 'quickstart' 'default'
    Seed-Answer $runDir 'Q0.8' 'none-known' 'quickstart' 'default'
    Seed-Answer $runDir 'Q1.2' 'O-GTM' 'quickstart' 'default'
    Seed-Answer $runDir 'Q1.3' 'accept 300-50-10' 'quickstart' 'default'
    Seed-Answer $runDir 'Q1.4' 'TBD' 'quickstart' 'default'
    Seed-Answer $runDir 'QN.0' "$title PROVISIONAL" 'quickstart' 'default'
    Seed-Answer $runDir 'Q3.1' "USD + $year" 'quickstart' 'default'
    Seed-Answer $runDir 'Q4.2' 'none-known' 'quickstart' 'default'
    Seed-Answer $runDir 'Q4.3' 'none-known' 'quickstart' 'default'
    Seed-Answer $runDir 'Q10.1' 'Logo Typography Color Packaging Donts' 'quickstart' 'default'
    Seed-Answer $runDir 'Q13.1' 'accept default thresholds' 'quickstart' 'default'
    Seed-Answer $runDir 'QRP.1' 'standard English' 'quickstart' 'default'
    if ($Variant -eq 'Campaign') { Seed-Answer $runDir 'QC.1' 'proven first pre-checked' 'quickstart' 'default' }
    Write-SourcesTemplate $runDir $Form
    if ($Preset) {
      Write-Output "INIT: run $RunId ($Variant, defaults, preset $Preset, form $Form) opened at phase $first"
      Write-Output 'SEEDED: Q0.0-Q0.5 (preset, src=asked) + Q0.6 form (flag, src=asked) + Q0.7, Q0.8, Q1.1-Q1.4, QN.0, Q3.1, Q4.2, Q4.3, Q10.1, Q13.1, QRP.1 (doc defaults, src=default)'
    } else {
      Write-Output "INIT: run $RunId ($Variant, defaults, provider $($qprow.id), form $Form) opened at phase $first"
      Write-Output 'SEEDED: Q0.0-Q0.1 (+Q0.1m, Q0.2, src=asked) + Q0.6 form (flag, src=asked) + Q0.7, Q0.8, Q1.1-Q1.4, QN.0, Q3.1, Q4.2, Q4.3, Q10.1, Q13.1, QRP.1 (doc defaults, src=default)'
      Write-Output 'PHASE-0 ASK: Q0.3 layout, Q0.4 fonts, Q0.5 cap (+Q0.1m/Q0.2m unless seeded) — answer, then run again.'
    }
    Write-Output 'FIRST INTERRUPT: tick the SOURCES.log pack checklist (append S<nn> lines) — S0 spec-sha must resolve in it, or the S0 exit-lock goes red.'
    Write-Output 'NOT SEEDED (confirm at phase, then run again): Q3.3, Q5.1, Q5.2, Q6.1, Q7.1, Q8.1, Q8.2, Q9.1-Q9.3, Q11.1-Q11.3, Q12.1, Q12.2, Q14.1'
    Write-Output 'NEVER DEFAULTED (always asked live): Q14.2 kill/launch-hold confirms, QN.4 trademark/domain/handle checks'
    if ($Variant -eq 'Rebrand') { Write-Output 'REBRAND: QR.1 equity sort has no default — answer before phase 0 closes.' }
    Write-Output "NEXT: do the phase work, then ftb.ps1 run -RunId $RunId (auto-advances until BLOCKED)"
    $r = Repo-Pwsh 'Enter-Phase.ps1' @('-RunDir', $runDir, '-Phase', $first, '-Variant', $Variant)
    $r.out | Write-Output
    exit $r.code
  }
  'run' {
    if (-not $RunId) { Write-Output 'RESULT: BLOCKED (need -RunId or $env:FTB_RUN)'; exit 1 }
    $st = Read-State $RunId
    if (-not $st) { Write-Output "RESULT: BLOCKED (run $RunId not initialized; ftb.ps1 quickstart first)"; exit 1 }
    for ($i = 1; $i -le $MaxSteps; $i++) {
      $r = Repo-Pwsh 'ftb.ps1' @('next', '-RunId', $RunId)
      $r.out | Write-Output
      if ($r.out -match 'COMPLETE:') { exit 0 }
      if ($r.code -ne 0) {
        Write-Output "RUN-STOP: blocked — answer the ask-list above (record in PARAMS.log), then ftb.ps1 run -RunId $RunId again."
        exit 1
      }
    }
    Write-Output "RUN-STOP: still advancing after $MaxSteps steps — re-run ftb.ps1 run -RunId $RunId to continue."
    exit 1
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
    # 1b. naming-lock on its phases (Validate-Naming self-skips when S0 says n/a)
    foreach ($ns in $namingStages[[int]$st.phase]) {
      if (-not $ns) { continue }
      $r = Repo-Pwsh 'Validate-Naming.ps1' @('-RunDir', $runDir, '-Stage', $ns)
      if ($r.code -ne 0) {
        Write-Output "NAMING-LOCK: phase $($st.phase) cannot close (Validate-Naming -Stage $ns RED):"
        ($r.out -split "`n" | Where-Object { $_ -match '^FAIL' }) | Write-Output
        Write-Output "RESULT: BLOCKED (see bridge/NAMING.md N3-N5, then ftb.ps1 next)"
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
  default { Write-Output "RESULT: BLOCKED (unknown command $Command; want init|quickstart|run|next|ask|status)"; exit 1 }
}


