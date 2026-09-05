<#Requires -Version 7.0
<#
.SYNOPSIS
  Report export chain for fit-to-brand: Markdown -> HTML -> PDF.
.DESCRIPTION
  Export-Report.ps1 -Path runs/<id>/bridge/R-<KIND>-<slug>.md [-Formats html,pdf]
  Writes the .html (pandoc, standalone HTML5 + hooks/export/print.css) and the
  .pdf (Edge/Chromium headless --print-to-pdf, A4, backgrounds on, no
  header/footer) next to the source. The .md stays the source of truth:
  re-export after any edit. Missing-image discipline: the source must use
  labeled placeholder boxes (div.img-slot), never dangling <img> — a PDF with
  broken images is a draft. Prerequisites: REQUIREMENTS.md (pandoc 3.x, Edge).
  Contract: bridge/REPORTS.md (d) Export.
#>
param(
  [Parameter(Mandatory)][string]$Path,
  [string[]]$Formats = @('html', 'pdf'),
  [string]$Css = ''
)

$ErrorActionPreference = 'Stop'
$HooksDir = Split-Path -Parent $PSCommandPath
$RepoRoot = Split-Path -Parent $HooksDir
if (-not $Css) { $Css = Join-Path $HooksDir 'export/print.css' }

$mdPath = $Path
if (-not [IO.Path]::IsPathRooted($mdPath)) { $mdPath = Join-Path (Get-Location) $mdPath }
if (-not (Test-Path -LiteralPath $mdPath)) { Write-Output "RESULT: BLOCKED (missing $Path)"; exit 1 }
$dir = Split-Path -Parent $mdPath
$base = [IO.Path]::GetFileNameWithoutExtension($mdPath)
$htmlPath = Join-Path $dir "$base.html"
$pdfPath = Join-Path $dir "$base.pdf"

function Resolve-Bin($cmd, $known) {
  $hit = Get-Command $cmd -ErrorAction SilentlyContinue
  if ($hit) { return ($hit.Source ? $hit.Source : $cmd) }
  foreach ($cand in $known) { if (Test-Path -LiteralPath $cand) { return $cand } }
  return $null
}

if ($Formats -contains 'html') {
  $pandoc = Resolve-Bin 'pandoc' @("$env:LOCALAPPDATA\Pandoc\pandoc.exe",
    'C:\Program Files\Pandoc\pandoc.exe', 'C:\Program Files (x86)\Pandoc\pandoc.exe')
  if (-not $pandoc) { Write-Output 'RESULT: BLOCKED (missing pandoc 3.x — see REQUIREMENTS.md; open a fresh shell after install)'; exit 1 }
  $title = $base -replace '^R-[A-Z]+-', '' -replace '-', ' '
  & "$pandoc" --standalone -f markdown -t html5 --resource-path="$dir" -c "$Css" `
    -V "pagetitle:$title" --metadata "title:$title" "$mdPath" -o "$htmlPath"
  if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $htmlPath)) {
    Write-Output 'RESULT: RED (pandoc HTML failed)'; exit 1
  }
  Write-Output "HTML: wrote $htmlPath ($((Get-Item -LiteralPath $htmlPath).Length) bytes)"
}

if ($Formats -contains 'pdf') {
  if (-not (Test-Path -LiteralPath $htmlPath)) {
    Write-Output 'RESULT: BLOCKED (PDF needs the HTML — run with -Formats html,pdf)'; exit 1
  }
  $edge = Get-Command msedge -ErrorAction SilentlyContinue
  if (-not $edge) {
    foreach ($cand in @('C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
        'C:\Program Files\Microsoft\Edge\Application\msedge.exe')) {
      if (Test-Path -LiteralPath $cand) { $edge = @{ Source = $cand }; break }
    }
  }
  if (-not $edge) {
    $chrome = Get-Command chrome, chromium -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($chrome) { $edge = $chrome } else {
      Write-Output 'RESULT: BLOCKED (no Edge/Chromium for --print-to-pdf — see REQUIREMENTS.md)'; exit 1
    }
  }
  $bin = ($edge.Source ? $edge.Source : $edge.Path)
  $url = 'file:///' + ($htmlPath -replace '\\', '/')
  & "$bin" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf="$pdfPath" "$url" 2>&1 | Out-Null
  if (-not (Test-Path -LiteralPath $pdfPath) -or (Get-Item -LiteralPath $pdfPath).Length -eq 0) {
    Write-Output 'RESULT: RED (print-to-pdf failed)'; exit 1
  }
  Write-Output "PDF: wrote $pdfPath ($((Get-Item -LiteralPath $pdfPath).Length) bytes)"
}

Write-Output 'RESULT: GREEN (export complete; .md unchanged and still source of truth)'
exit 0

