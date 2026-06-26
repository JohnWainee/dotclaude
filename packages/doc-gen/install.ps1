<#
  doc-gen — standalone installer (Windows / PowerShell).
  Installs the /doc-gen command, template pack spec, and template packs into
  %USERPROFILE%\.claude (or $env:CLAUDE_CONFIG_DIR). Does NOT require the full
  dotclaude repo.

  Prerequisite: the IBM Documentation Style package must be installed separately.

  Usage:  .\install.ps1
#>
$ErrorActionPreference = "Stop"

$Pkg = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { "$env:USERPROFILE\.claude" }
$Ts = Get-Date -Format "yyyyMMdd-HHmmss"

function Backup($p) { if (Test-Path $p) { Copy-Item $p "$p.bak-$Ts" -Force; Write-Host "  backed up $(Split-Path -Leaf $p)" } }

Write-Host "Installing doc-gen into: $ClaudeDir"

foreach ($d in "commands","references") {
  New-Item -ItemType Directory -Force -Path "$ClaudeDir\$d" | Out-Null
  foreach ($f in Get-ChildItem "$Pkg\$d" -File) {
    Backup "$ClaudeDir\$d\$($f.Name)"
    Copy-Item $f.FullName "$ClaudeDir\$d\$($f.Name)" -Force
    Write-Host "  installed $d/$($f.Name)"
  }
}

# --- template packs ---
if (Test-Path "$Pkg\templates") {
  Copy-Item "$Pkg\templates\*" "$ClaudeDir\templates" -Recurse -Force
  Write-Host "  installed templates/"
}

Write-Host ""

# --- check for IBM style dependency ---
if (-not (Test-Path "$ClaudeDir\references\ibm-documentation-style.md")) {
  Write-Host "WARNING: IBM Documentation Style reference not found."
  Write-Host "  /doc-gen requires the IBM doc style package as a dependency."
  Write-Host "  Install it first from packages/ibm-doc-style/ or"
  Write-Host "  https://github.com/JohnWainee/dotclaude"
  Write-Host ""
}

Write-Host "Installed. Restart Claude Code to load the new /doc-gen command."
