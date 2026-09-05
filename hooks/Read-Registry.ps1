#Requires -Version 7.0
<#
Shared provider-registry reader for fit-to-brand hooks.
Dot-source from hook scripts: . (Join-Path $HooksDir 'Read-Registry.ps1')
Single source of truth is bridge/PROVIDERS.md (9-column table); there is no
mirror file, so this parser and the table must agree on the shape.
No secrets are handled here — only ids, URLs, and capability flags.
#>

function Read-RegistryTable($tablePath) {
  # rows of one 9-column registry table file. ALWAYS returns a real array
  # (possibly empty — never $null: callers wrap in @() and a $null element
  # would crash member access downstream).
  $rows = @()
  if (Test-Path -LiteralPath $tablePath) {
    foreach ($line in (Get-Content -LiteralPath $tablePath)) {
      if ($line -notmatch '^\s*\|') { continue }
      $cells = @($line.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() })
      if ($cells.Count -ne 9) { continue }
      if ($cells[0] -eq 'id' -or $cells[0] -match '^-+$') { continue }
      $rows += [pscustomobject]@{
        id = $cells[0]; aliases = $cells[1]; baseURL = $cells[2]; probe = $cells[3]
        keyEnv = $cells[4]; images = $cells[5]; video = $cells[6]
        defaults = $cells[7]; notes = $cells[8]
      }
    }
  }
  Write-Output -NoEnumerate $rows
}

function Get-RegistryRows($repoRoot) {
  Write-Output -NoEnumerate (Read-RegistryTable (Join-Path $repoRoot 'bridge/PROVIDERS.md'))
}

function Resolve-RegistryRow($rows, $id) {
  # canonical row for an id/alias (case-insensitive), or $null.
  if ([string]::IsNullOrWhiteSpace($id)) { return $null }
  $want = $id.Trim().ToLower()
  foreach ($r in @($rows)) {
    if ($null -eq $r -or $null -eq $r.id) { continue }
    if ($r.id.ToLower() -eq $want) { return $r }
    $aka = @($r.aliases -split '[,;\s]+' | Where-Object { $_ -ne '' -and $_ -ne '—' } | ForEach-Object { $_.ToLower() })
    if ($aka -contains $want) { return $r }
  }
  return $null
}

function Test-ProbeSkipped($row) {
  # rows with no HTTP probe surface: key check (Test-Provider) or nothing further.
  return ($row.probe -eq '' -or $row.probe -eq '—' -or $row.probe -eq 'none')
}
