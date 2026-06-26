<#
  IBM Documentation Style — standalone installer (Windows / PowerShell).
  Installs the reference file and /doc-style command into %USERPROFILE%\.claude
  (or $env:CLAUDE_CONFIG_DIR). Does NOT require the full dotclaude repo.

  Usage:  .\install.ps1
#>
$ErrorActionPreference = "Stop"

$Pkg = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { "$env:USERPROFILE\.claude" }
$Ts = Get-Date -Format "yyyyMMdd-HHmmss"

function Backup($p) { if (Test-Path $p) { Copy-Item $p "$p.bak-$Ts" -Force; Write-Host "  backed up $(Split-Path -Leaf $p)" } }

Write-Host "Installing IBM Documentation Style into: $ClaudeDir"

foreach ($d in "references","commands") {
  New-Item -ItemType Directory -Force -Path "$ClaudeDir\$d" | Out-Null
  foreach ($f in Get-ChildItem "$Pkg\$d" -File) {
    Backup "$ClaudeDir\$d\$($f.Name)"
    Copy-Item $f.FullName "$ClaudeDir\$d\$($f.Name)" -Force
    Write-Host "  installed $d/$($f.Name)"
  }
}

Write-Host ""
Write-Host "Installed. Two manual steps remain:"
Write-Host ""
Write-Host "1. Add the CLAUDE.md snippet to your global or project CLAUDE.md."
Write-Host "   The snippet is at: $Pkg\snippets\claude-md-snippet.md"
Write-Host ""
Write-Host "2. (Optional) Integrate with /review-pr."
Write-Host "   Instructions at: $Pkg\snippets\review-pr-agent-snippet.md"
Write-Host ""
Write-Host "Restart Claude Code to load the new command."
