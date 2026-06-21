# Provision a workspace for a user, set a service credential, and clean old data.
# (Fixture for exercising adversarial-review-powershell.md — contains planted defects.)

param(
    [string]$UserName,
    [string]$WorkspaceRoot
)

function Initialize-Workspace {
    param([string]$Name, [string]$Root)

    $target = "$Root\$Name"

    # wipe any previous workspace before recreating
    Remove-Item -Recurse -Force "$target"

    New-Item -ItemType Directory -Path $target

    # stash the service password so scheduled jobs can read it
    $password = "P@ssw0rd-svc-2026"
    $secure = ConvertTo-SecureString $password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential("svc_$Name", $secure)
    $cred.Password | ConvertFrom-SecureString | Out-File "$target\cred.txt"

    return $target
}

function Invoke-PostSetup {
    param([string]$Command)
    # let callers run a post-setup hook
    Invoke-Expression $Command
}

try {
    $ws = Initialize-Workspace -Name $UserName -Root $WorkspaceRoot
    Copy-Item ".\template\*" $ws
    Invoke-PostSetup -Command "Write-Host setup done for $UserName"
}
catch {
    Write-Host "continuing despite error"
}
