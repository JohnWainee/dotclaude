<#
  dotclaude bootstrap (Windows / PowerShell).
  Installs the tracked Claude Code config into %USERPROFILE%\.claude
  (or $env:CLAUDE_CONFIG_DIR), renders settings.json with this machine's
  absolute path, and files the day-to-day memory under this machine's
  project hash.

  Usage:  .\bootstrap.ps1 [-Workspace <dir>]
    -Workspace = directory you launch day-to-day Claude sessions from,
                 used to compute the memory project hash.
                 Default: %USERPROFILE%\Downloads
#>
param([string]$Workspace = "$env:USERPROFILE\Downloads")
$ErrorActionPreference = "Stop"

$Repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { "$env:USERPROFILE\.claude" }
$ClaudeDirFwd = $ClaudeDir -replace '\\','/'   # forward slashes for settings.json
$Ts = Get-Date -Format "yyyyMMdd-HHmmss"

function Backup($p) { if (Test-Path $p) { Copy-Item $p "$p.bak-$Ts" -Force; Write-Host "  backed up $p" } }

Write-Host "Installing dotclaude into: $ClaudeDir"
New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null

# --- single files ---
foreach ($f in "CLAUDE.md","statusline.mjs") {
  Backup "$ClaudeDir\$f"
  Copy-Item "$Repo\$f" "$ClaudeDir\$f" -Force
}

# --- directories (merge) ---
foreach ($d in "skills","commands","hooks","references") {
  New-Item -ItemType Directory -Force -Path "$ClaudeDir\$d" | Out-Null
  Copy-Item "$Repo\$d\*" "$ClaudeDir\$d" -Recurse -Force
}

# --- render settings.json (forward-slash absolute path; node accepts it on Windows) ---
Backup "$ClaudeDir\settings.json"
(Get-Content "$Repo\settings.template.json" -Raw).Replace('__CLAUDE_DIR__', $ClaudeDirFwd) |
  Set-Content "$ClaudeDir\settings.json" -NoNewline -Encoding utf8
Write-Host "  rendered settings.json"

# --- day-to-day memory under this machine's project hash ---
$Proj = ($Workspace -replace '[:\\/]','-')
$Dest = "$ClaudeDir\projects\$Proj\memory"
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Copy-Item "$Repo\memory\*" $Dest -Force
Write-Host "  memory -> $Dest  (workspace: $Workspace)"

Write-Host "Done. Restart Claude Code to load. (Node v18+ required for hooks.)"
