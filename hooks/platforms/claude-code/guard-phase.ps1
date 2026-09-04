<#Requires -Version 7.0
<#
.SYNOPSIS
  Claude Code PreToolUse guard: blocks writes to future-phase run files.
.DESCRIPTION
  Reads hook JSON from stdin ({tool_name, tool_input:{file_path}}). If the target
  lives under <bundle>/runs/<id>/ and that run has STATE.json, maps the path to its
  earliest phase and compares with STATE.phase. Writes to phases beyond the current
  one are BLOCKED (exit 2 + reason on stderr = Claude Code blocking convention).
  GATES.log / PARAMS.log / STATE.json are always writable (they ARE the locks).
  Install: merge hooks.json into .claude/settings.json (project) and set the command
  path to this file. No STATE.json under the path = not an ftb run = allow silently.
#>
param([string]$RepoRoot = $env:FIT_TO_BRAND_ROOT)

$ErrorActionPreference = 'Stop'
try { $input2 = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch { exit 0 }
$path = $input2.tool_input.file_path
if (-not $path) { exit 0 }

function Find-Root($from, $marker) {
  $d = Split-Path -Parent ([IO.Path]::GetFullPath($from))
  while ($d) {
    if (Test-Path -LiteralPath (Join-Path $d $marker)) { return $d }
    $p = Split-Path -Parent $d
    if ($p -eq $d) { break }
    $d = $p
  }
  return $null
}

$root = $RepoRoot
if (-not $root) { $root = Find-Root $path (Join-Path 'hooks' 'ftb.ps1') }
if (-not $root) { exit 0 }  # bundle not present above path: not our jurisdiction
$full = [IO.Path]::GetFullPath($path)
$rel = [IO.Path]::GetRelativePath($root, $full)
if ($rel -match '^\.\.') { exit 0 }  # outside bundle
$m = [regex]::Match($rel, '^runs[\\/]+([^\\/]+)[\\/]+(.*)$')
if (-not $m.Success) { exit 0 }  # not inside a run workspace
$runId, $rest = $m.Groups[1].Value, ($m.Groups[2].Value -replace '\\', '/')
$stateP = Join-Path $root "runs/$runId/STATE.json"
if (!(Test-Path -LiteralPath $stateP)) { exit 0 }
$st = Get-Content -LiteralPath $stateP -Raw | ConvertFrom-Json

function File-Phase($rest, $variant) {
  if ($rest -match '^(GATES\.log|PARAMS\.log|STATE\.json)$') { return 0 }
  if ($variant -eq 'Campaign') {
    if ($rest -match '^icp/') { return 1 }
    if ($rest -match '^bridge/M_PREDICTIONS') { return 1 }
    if ($rest -match '^bridge/M1_|^bridge/M2_OBS|^bridge/M3_') { return 5 }
    if ($rest -match '^bridge/') { return 1 }
    if ($rest -match '^brand/') { return 2 }
    return 99
  }
  if ($rest -match '^icp/(S0_SPEC|Appendix_Raw)') { return 1 }
  if ($rest -match '^icp/(S2_|S3_)') { return 2 }
  if ($rest -match '^icp/(S4_|S5A_|NOTFIT)') { return 3 }
  if ($rest -match '^icp/S5B_') { return 4 }
  if ($rest -match '^brand/') { return 5 }
  if ($rest -match '^bridge/THREADS') { return 7 }
  if ($rest -match '^bridge/M_PREDICTIONS|^bridge/M0_') { return 9 }
  if ($rest -match '^bridge/M1_|^bridge/M2_OBS|^bridge/M3_') { return 10 }
  if ($rest -match '^bridge/') { return 4 }
  return 99
}

$need = File-Phase $rest $st.variant
if ($need -gt [int]$st.phase) {
  [Console]::Error.WriteLine("ftb guard: BLOCKED — runs/$runId/$rest belongs to phase $need but run $($st.run) is in phase $($st.phase). Advance only via hooks/ftb.ps1 next (it runs the exit/entry locks). Working ahead silently is how silent runs happen.")
  exit 2
}
exit 0
