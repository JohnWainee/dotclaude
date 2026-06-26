---
name: Windows Infrastructure
description: >
  Documentation for Windows server administration — component references,
  environment documentation, operational runbooks, change management guides,
  and troubleshooting guides.
detect:
  - { pattern: "*.mof", weight: 3 }
  - { pattern: "DSCResources", weight: 3 }
  - { pattern: "*.admx", weight: 3 }
  - { pattern: "*.adml", weight: 3 }
  - { pattern: "web.config", weight: 2 }
  - { pattern: "applicationHost.config", weight: 2 }
  - { pattern: "*.reg", weight: 2 }
  - { pattern: "*.bat", weight: 1 }
  - { pattern: "*.cmd", weight: 1 }
  - { pattern: "*.ps1", weight: 1 }
min-confidence: 3
doc-types:
  - { id: "project-readme", name: "Project documentation overview", output-path: "docs/README.md", scope: "per-repo" }
  - { id: "component-reference", name: "Component reference", output-path: "docs/modules/{component}/README.md", scope: "per-module" }
  - { id: "environment-reference", name: "Environment reference", output-path: "docs/reference/environment.md", scope: "per-repo" }
  - { id: "operational-runbook", name: "Operational runbook", output-path: "docs/runbooks/{topic}.md", scope: "per-module" }
  - { id: "change-management", name: "Change management guide", output-path: "docs/guides/change-management.md", scope: "per-repo" }
  - { id: "troubleshooting", name: "Troubleshooting guide", output-path: "docs/troubleshooting/windows-infra.md", scope: "per-repo" }
---

## Context gathering

### project-readme

Read the root directory structure to understand the overall organization. Read
any existing `README.md` for context to preserve. Identify the top-level
directories to understand what infrastructure components this repo manages.

Read all `*.ps1`, `*.bat`, and `*.cmd` files in the root directory (not
recursively) to understand the primary entry points and their purposes. Extract
script names and any comment-based help blocks.

### component-reference

Read all scripts (`*.ps1`, `*.bat`, `*.cmd`) in the component directory. For each
script, extract:
- The file name and purpose (from comment-based help or header comments).
- Parameters (from `param()` blocks or `%1`, `%2` batch parameters).
- Required permissions or elevation (`#Requires -RunAsAdministrator`, or
  references to `Run as Administrator`).
- Dependencies (modules imported via `Import-Module`, external tools invoked).

Read any configuration files in the component directory:
- `*.xml`, `*.json`, `*.ini`, `*.config` — note their purpose.
- `*.mof` — DSC configuration artifacts.
- `*.reg` — registry modifications.
- `*.admx`, `*.adml` — Group Policy definitions.

Read any existing documentation in the component directory.

### environment-reference

Scan all scripts for references to:
- Server names or IP addresses (patterns like `$Server`, `$ComputerName`,
  `-ComputerName`, connection strings).
- Service accounts (patterns like `$Credential`, `$ServiceAccount`, references to
  domain accounts in `DOMAIN\user` format).
- Required PowerShell modules (`Import-Module`, `#Requires -Modules`).
- Windows features or roles (`Install-WindowsFeature`, `Add-WindowsFeature`).
- Group Policy references (`Get-GPO`, `Set-GPLink`, Group Policy paths).
- Network configuration (DNS, DHCP, IP addressing).
- Certificate references (certificate stores, `Get-ChildItem Cert:\`).

Read any environment-specific configuration files (`*.env`, `*config*.json`,
`*config*.xml`, `*.ini`).

Do not extract actual credentials, passwords, or sensitive values. Note only the
parameter names and where they are used.

### operational-runbook

Read all scripts in the component directory. For each script that performs an
operational task (deployment, maintenance, backup, restoration, configuration
change):
- Extract the full parameter list with descriptions.
- Identify the sequence of operations the script performs.
- Identify pre-conditions (services that must be running, permissions needed,
  maintenance windows).
- Identify verification steps (how to confirm success).
- Identify rollback steps (how to undo the change).

Read any existing runbooks or procedure documentation.

### change-management

Scan the repository for:
- Deployment scripts and their parameters.
- Configuration files that control behavior across environments.
- Any existing change management documentation or templates.
- Test scripts (`*.Tests.ps1`, `*test*` directories).
- Backup or snapshot scripts.
- Version-controlled configuration baselines.

### troubleshooting

Scan all scripts for patterns that indicate which Windows services and roles are
managed:
- Active Directory: `Get-AD*`, `Set-AD*`, `New-AD*`, `Import-Module
  ActiveDirectory`, DSC `xActiveDirectory` resources.
- DNS: `Get-DnsServer*`, `Add-DnsServer*`, `Resolve-DnsName`.
- DHCP: `Get-DhcpServer*`, `Add-DhcpServer*`.
- IIS: `Get-WebSite`, `New-WebSite`, `Import-Module WebAdministration`,
  `web.config` files.
- File Server: `Get-SmbShare`, `New-SmbShare`, NTFS permission commands.
- Group Policy: `Get-GPO`, `Set-GPLink`, `Backup-GPO`.
- Certificate Services: `Get-Certificate`, `certutil`, certificate store
  operations.
- Windows services: `Get-Service`, `Set-Service`, `Restart-Service`.
- Scheduled tasks: `Get-ScheduledTask`, `Register-ScheduledTask`.
- Event logs: `Get-EventLog`, `Get-WinEvent`.

Read error-handling patterns in scripts (`try`/`catch` blocks, `$ErrorActionPreference`
settings) to understand common failure modes.

## Generation instructions

Follow the IBM Documentation Style Guide at
`~/.claude/references/ibm-documentation-style.md` for all generated content.

### project-readme

Generate a project documentation overview with these sections:

- **Overview** — One to two paragraphs describing what infrastructure this
  repository manages and its purpose.
- **Infrastructure components** — Table of components this repo covers. Columns:
  Component, Description, Link (to component reference doc).
- **Prerequisites** — What you need before using these scripts:
  - Required permissions and group memberships.
  - Required PowerShell modules and versions.
  - Required server access or network connectivity.
  - Required tools (RSAT features, and others).
- **Quick start** — Numbered steps to get started: clone, configure environment,
  run a common operation.
- **Component index** — Table linking to each component's reference documentation
  in `docs/modules/`. Columns: Component, Purpose, Link.
- **Additional documentation** — Links to runbooks, environment reference,
  change management guide, and troubleshooting guide.

### component-reference

Generate a component reference document with these sections:

- **Purpose** — One paragraph describing what infrastructure this component
  manages and when you use it.
- **Scripts** — Table of all scripts in this component. Columns: Script,
  Purpose, Parameters summary, Elevation required.
- **Configuration files** — Table of configuration files. Columns: File,
  Format, Purpose, When to modify.
- **Dependencies** — Required PowerShell modules, Windows features, external
  tools, and other components this one depends on.
- **Required permissions** — Specific permissions, group memberships, or
  elevation required to run scripts in this component. Be specific: name the AD
  groups, delegation requirements, or local admin needs.
- **Related components** — Links to other components this one interacts with.

### environment-reference

Generate an environment reference document with these sections:

- **Overview** — One paragraph describing the infrastructure environment this
  repo manages.
- **Servers and roles** — Table of servers or server roles referenced in scripts.
  Columns: Server or role, Purpose, Key services. Do not include IP addresses or
  credentials.
- **Service accounts** — Table of service accounts referenced. Columns: Account
  reference (parameter name, not the actual account), Purpose, Where used.
  Do not document actual account names or passwords.
- **Required PowerShell modules** — Table of modules imported across all scripts.
  Columns: Module, Version (if specified), Used by (script names).
- **Windows features and roles** — List of Windows features installed or required
  by scripts.
- **Group Policy references** — If Group Policy objects are referenced, list them
  with their purpose.
- **Network dependencies** — Ports, protocols, or connectivity requirements
  identified in scripts.
- **Certificate requirements** — Certificate stores, certificate types, or PKI
  dependencies if referenced.

Note: This document catalogs what the scripts reference, not the live environment
state. It serves as a baseline for understanding dependencies.

### operational-runbook

Generate an operational runbook for each component that performs operational
tasks. Each runbook covers a specific operational procedure.

Sections:

- **Purpose** — What this runbook covers and when to use it.
- **Prerequisites** — What must be in place before you start: permissions, server
  access, maintenance window, change approval.
- **Pre-checks** — Numbered steps to verify readiness before making changes.
  Include specific commands to run and what to verify in the output.
- **Procedure** — Numbered steps to perform the operation. For each step:
  - State the action in imperative mood.
  - Include the actual script or command to run with parameters.
  - State what to expect as output.
  - Note any wait times or dependencies on previous steps.
- **Verification** — Numbered steps to confirm the operation succeeded. Include
  specific commands and expected output.
- **Rollback** — Numbered steps to undo the change if something goes wrong.
  Include the specific scripts or commands for rollback.
- **Escalation** — When to escalate and to whom (leave as a placeholder for the
  team to fill in).

Use numbered steps for all procedures. One action per step. Imperative mood.
Include actual script names and parameter values from the codebase.

### change-management

Generate a change management guide with these sections:

- **Purpose** — Explain the change management process for this infrastructure.
- **Change request checklist** — Bulleted checklist of items required before
  making a change:
  - Change description and justification.
  - Affected systems and services.
  - Risk assessment (impact, likelihood, blast radius).
  - Maintenance window requirements.
  - Communication plan.
  - Approval status.
- **Testing requirements** — How to test changes before applying to production.
  Reference any test scripts (`*.Tests.ps1`) found in the codebase. Include steps
  for testing in a non-production environment.
- **Deployment procedure** — Numbered steps for deploying a change. Reference
  actual deployment scripts from the codebase.
- **Rollback plan** — How to reverse a change. Reference actual rollback or
  backup scripts from the codebase.
- **Post-change verification** — Steps to confirm the change was applied
  correctly and no regressions occurred.
- **Communication template** — A template for notifying stakeholders (leave
  sections as placeholders for the team to fill in: audience, timing, content).

### troubleshooting

Generate a troubleshooting guide with symptom-based sections. Include only
sections for Windows services and roles that are actually managed by scripts in
this repository. Do not generate troubleshooting for services not present.

For each service found, use this structure:
1. **Symptom** — The observable behavior or error message.
2. **Cause** — Why this happens.
3. **Diagnostic steps** — Commands to investigate the issue.
4. **Resolution** — Numbered steps to fix it, referencing scripts from the
   codebase where applicable.

Common sections (include only if the corresponding service is present):

- **Active Directory replication failures** — Symptoms: `repadmin /showrepl`
  shows errors. Diagnostic: `dcdiag`, `repadmin`, event log checks. Resolution.
- **DNS resolution failures** — Symptoms: name resolution fails. Diagnostic:
  `Resolve-DnsName`, `nslookup`, DNS server event logs. Resolution.
- **DHCP scope exhaustion** — Symptoms: clients cannot obtain addresses.
  Diagnostic: `Get-DhcpServerv4Scope`, scope statistics. Resolution.
- **IIS application pool crashes** — Symptoms: HTTP 503 errors, application pool
  stopped. Diagnostic: event viewer, `Get-WebAppPoolState`. Resolution.
- **Service startup failures** — Symptoms: service fails to start. Diagnostic:
  `Get-Service`, event logs, dependency chain. Resolution. Tailor to the specific
  services managed by scripts in this repo.
- **Group Policy application failures** — Symptoms: `gpresult` shows policies not
  applied. Diagnostic: `gpresult /h`, `Get-GPResultantSetOfPolicy`. Resolution.
- **Permission and access errors** — Symptoms: "Access Denied" in scripts.
  Diagnostic: check group membership, delegation, UAC. Resolution.
- **Scheduled task failures** — Symptoms: task shows "Last Run Result" error.
  Diagnostic: `Get-ScheduledTask`, task history, event logs. Resolution.

## Module boundary detection

A Windows Infrastructure "component" represents a functional grouping of scripts
and configurations that manage a specific part of the infrastructure.

Discovery rules:

1. The root target directory is always treated as a component.
2. Each top-level subdirectory that contains at least one script file (`*.ps1`,
   `*.bat`, `*.cmd`) or configuration file (`*.mof`, `*.admx`, `web.config`,
   `*.reg`) is a component boundary.
3. Directories that follow common naming conventions for server roles are
   components: `AD`, `ActiveDirectory`, `DNS`, `DHCP`, `IIS`, `FileServer`,
   `GPO`, `GroupPolicy`, `PKI`, `Certificates`, `Backup`, `Monitoring`,
   `Security`, `Network`, `Storage`, `Print`, `Exchange`, `SQL`, `SCCM`, `WSUS`,
   `Hyper-V`, `RDS`, `Clustering`.
4. Directories containing DSC configurations (`.mof` files or `.ps1` files with
   `Configuration` blocks) are components.
5. Ignore directories named `.git/`, `logs/`, `output/`, `archive/`, `temp/`,
   `backup/`, `old/`, `.vscode/`.

To discover components, run:
```
find <target> -maxdepth 2 \( -name "*.ps1" -o -name "*.bat" -o -name "*.cmd" -o -name "*.mof" -o -name "*.admx" -o -name "web.config" -o -name "*.reg" \) -not -path "*/.git/*" -not -path "*/logs/*" -not -path "*/output/*"
```

Group results by their parent directory. Each directory with at least one matching
file is a candidate component.

For operational runbooks, generate one runbook per component that contains scripts
performing operational tasks (deployment, configuration, maintenance). Use the
component name as the `{topic}` in the output path.
