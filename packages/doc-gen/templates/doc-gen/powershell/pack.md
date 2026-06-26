---
name: PowerShell Module
description: >
  Documentation for PowerShell modules — function references, parameter
  catalogs, installation guides, usage examples, and troubleshooting guides.
detect:
  - { pattern: "*.psm1", weight: 3 }
  - { pattern: "*.psd1", weight: 3 }
  - { pattern: "Public", weight: 2 }
  - { pattern: "Private", weight: 2 }
  - { pattern: "Functions", weight: 2 }
  - { pattern: "*.Tests.ps1", weight: 1 }
  - { pattern: "*.ps1", weight: 1 }
min-confidence: 3
doc-types:
  - { id: "project-readme", name: "Module overview", output-path: "docs/README.md", scope: "per-repo" }
  - { id: "function-reference", name: "Function reference", output-path: "docs/modules/{module}/functions.md", scope: "per-module" }
  - { id: "parameter-reference", name: "Parameter reference", output-path: "docs/modules/{module}/parameters.md", scope: "per-module" }
  - { id: "installation-guide", name: "Installation guide", output-path: "docs/guides/installation.md", scope: "per-repo" }
  - { id: "examples", name: "Usage examples", output-path: "docs/guides/examples.md", scope: "per-repo" }
  - { id: "troubleshooting", name: "Troubleshooting guide", output-path: "docs/troubleshooting/powershell.md", scope: "per-repo" }
---

## Context gathering

### project-readme

Read the module manifest (`.psd1`) file to extract:
- Module name and version (`ModuleVersion`).
- Description.
- Author.
- Required PowerShell version (`PowerShellVersion`).
- Required modules (`RequiredModules`).
- Exported functions (`FunctionsToExport`).
- Exported cmdlets, aliases, and variables.
- Tags and project URI.

Read the module file (`.psm1`) to understand the module's loading behavior (dot
sourcing patterns, initialization logic).

Read any existing `README.md` for context to preserve.

Count the total number of exported functions by scanning `Public/` or
`Functions/` directories.

### function-reference

Read all `.ps1` files in the module's function directories. The standard
convention is:
- `Public/` — exported functions (user-facing).
- `Private/` — internal helper functions (not exported).
- `Functions/` — alternative flat structure for all functions.
- Root `*.ps1` files that define functions (if no subdirectory structure).

For each function file, extract:
- Function name (from the `function` keyword).
- Comment-based help block (`<# .SYNOPSIS ... #>` or `# .SYNOPSIS` style):
  - `.SYNOPSIS` — one-line description.
  - `.DESCRIPTION` — detailed description.
  - `.PARAMETER` — per-parameter documentation.
  - `.EXAMPLE` — usage examples.
  - `.OUTPUTS` — return type documentation.
  - `.NOTES` — additional notes.
  - `.LINK` — related links.
- `[CmdletBinding()]` attribute and its parameters (SupportsShouldProcess,
  DefaultParameterSetName, and others).
- `[OutputType()]` attribute.
- Parameter block: for each parameter, extract:
  - Name.
  - Type (`[string]`, `[int]`, `[PSCredential]`, and others).
  - Mandatory attribute (`[Parameter(Mandatory)]` or `[Parameter(Mandatory = $true)]`).
  - Default value (if assigned in the `param()` block).
  - Validation attributes (`[ValidateSet()]`, `[ValidateRange()]`,
    `[ValidatePattern()]`, `[ValidateNotNullOrEmpty()]`, and others).
  - Pipeline input (`[Parameter(ValueFromPipeline)]`,
    `[Parameter(ValueFromPipelineByPropertyName)]`).
  - Parameter set name (`[Parameter(ParameterSetName = '...')]`).
  - Aliases (`[Alias('...')]`).
  - Position (`[Parameter(Position = 0)]`).

Separate exported (public) functions from internal (private) functions. Only
document public functions in the function reference. Mention that private
functions exist and their purpose, but do not document their parameters.

### parameter-reference

Use the same source data as `function-reference`. For each exported function,
extract the full parameter details. This doc type presents the data in a
consolidated, cross-function view rather than per-function.

### installation-guide

Read the module manifest (`.psd1`) for:
- Module name and version.
- Required PowerShell version.
- Required modules (dependencies).
- Minimum CLR version or .NET framework requirements.
- Processor architecture requirements.

Check for:
- `build.ps1` or `Build/` directory — module build system.
- `*.nuspec` — NuGet packaging.
- `PSGallery` references in any file — published to PowerShell Gallery.
- `requirements.psd1` — PSDepend dependency file.
- `.github/workflows/` — CI/CD publishing pipeline.
- `Invoke-Build` or `psake` references — build tool usage.

Read any existing installation or setup documentation.

### examples

Read all `.EXAMPLE` sections from comment-based help blocks across exported
functions. Read any files in `examples/`, `Examples/`, or `docs/examples/`
directories.

Read Pester test files (`*.Tests.ps1`) for usage patterns — test cases often
demonstrate real-world usage.

Read any existing example documentation or scripts.

### troubleshooting

Scan the module for common issues:
- Module import requirements (specific PowerShell version, required modules).
- Functions that require elevation (`#Requires -RunAsAdministrator`).
- Functions that accept credentials (`[PSCredential]` parameters).
- Functions that modify system state (contain `SupportsShouldProcess`).
- Functions with complex parameter validation that might reject input.
- Functions that call external commands or APIs (potential connectivity issues).
- Error handling patterns (`try`/`catch`, `$ErrorActionPreference`,
  `-ErrorAction`).

Read Pester tests for edge cases and known failure scenarios.

## Generation instructions

Follow the IBM Documentation Style Guide at
`~/.claude/references/ibm-documentation-style.md` for all generated content.

### project-readme

Generate a module overview document with these sections:

- **Overview** — One to two paragraphs describing what this module does, who it
  is for, and what problems it solves.
- **Features** — Bulleted list of the module's capabilities, derived from the
  exported functions.
- **Requirements** — Table of prerequisites. Columns: Requirement, Minimum
  version. Include PowerShell version, required modules, and any platform
  requirements.
- **Installation** — Brief installation steps (link to the full installation
  guide for details):
  - PowerShell Gallery: `Install-Module -Name <ModuleName>`
  - Manual: clone and import.
- **Quick start** — A short, complete code example showing the most common use
  case. Include `Import-Module`, function call, and expected output.
- **Function index** — Table of all exported functions. Columns: Function,
  Synopsis, Link (to function reference). Sort alphabetically.
- **Additional documentation** — Links to function reference, parameter
  reference, examples, installation guide, and troubleshooting guide.

### function-reference

Generate a function reference document with these sections:

- **Overview** — One sentence stating how many exported functions the module
  contains and their general purpose.
- **Function summary** — Table of all exported functions. Columns: Function,
  Synopsis. Sort alphabetically.
- **Detailed reference** — For each exported function, generate a subsection
  with:
  - **Synopsis** — One-line description from `.SYNOPSIS`.
  - **Description** — Full description from `.DESCRIPTION`. If no `.DESCRIPTION`
    exists, expand the synopsis.
  - **Syntax** — The function signature showing all parameters with their types.
    If the function has parameter sets, show one syntax block per parameter set.
  - **Parameters** — Table for each parameter. Columns: Name, Type, Required,
    Default, Pipeline, Description. Sort by position, then alphabetically.
    Include validation constraints in the description (for example,
    "Valid values: 'Start', 'Stop', 'Restart'").
  - **Outputs** — Return type and description. Derive from `[OutputType()]` or
    `.OUTPUTS` help.
  - **Examples** — Include examples from `.EXAMPLE` help. Each example must show
    the command and its expected output. If no examples exist in the help,
    generate a basic usage example based on the parameters.

Sort functions alphabetically. Use heading level 3 (`###`) for each function.

### parameter-reference

Generate a consolidated parameter reference document:

- **Overview** — One sentence describing the purpose of this reference.
- **Parameters by function** — For each exported function, generate a table.
  Columns: Parameter, Type, Required, Default, Pipeline, Validation, Description.
  - **Required column:** "Yes" if the Mandatory attribute is set, "No" otherwise.
  - **Pipeline column:** "ByValue" if `ValueFromPipeline`, "ByPropertyName" if
    `ValueFromPipelineByPropertyName`, "No" otherwise.
  - **Validation column:** Summarize validation attributes (for example,
    "Set: Start, Stop", "Range: 1-100", "NotNullOrEmpty").
- **Common parameters** — Note that all functions with `[CmdletBinding()]`
  support common parameters (`-Verbose`, `-Debug`, `-ErrorAction`, and others).
  Do not list common parameters in individual function tables.
- **Parameter sets** — If any function uses parameter sets, add a section
  explaining which parameters belong to which set and when to use each set.

### installation-guide

Generate an installation guide with these sections:

- **Prerequisites** — List all requirements:
  - PowerShell version.
  - Required modules (with version constraints if specified in the manifest).
  - Platform requirements (Windows, macOS, Linux) if applicable.
  - .NET or CLR requirements if specified.
- **Install from PowerShell Gallery** — Numbered steps:
  1. Open PowerShell.
  2. Run `Install-Module -Name <ModuleName>` (or with `-Scope CurrentUser`).
  3. Verify with `Get-Module -ListAvailable <ModuleName>`.
  Include only if the module appears to be published to PSGallery.
- **Install from source** — Numbered steps:
  1. Clone the repository.
  2. Run the build script (if one exists) or copy the module directory.
  3. Copy to a module path (`$env:PSModulePath`).
  4. Verify installation.
  If a build script exists, document its usage and parameters.
- **Import the module** — How to import and verify:
  ```powershell
  Import-Module <ModuleName>
  Get-Command -Module <ModuleName>
  ```
- **Configure** — If the module requires configuration (environment variables,
  config files, API keys), document the setup steps. Only include if
  configuration is evident from the codebase.
- **Update** — Steps to update the module from PSGallery or source.
- **Uninstall** — Steps to remove the module.

### examples

Generate a usage examples document with these sections:

- **Overview** — One sentence describing what examples are covered.
- **Examples** — Each example as a separate subsection with:
  - **Scenario** — One sentence describing the use case.
  - **Code** — Complete, runnable PowerShell code block. Include
    `Import-Module` if needed, the function call with realistic parameter values,
    and expected output as a comment.
  - **Explanation** — One to two sentences explaining what the code does and why
    you would use this pattern.

Source examples from:
1. `.EXAMPLE` sections in comment-based help (highest priority — these are
   author-provided).
2. Pester test cases (adapt assertions into usage examples).
3. Generated examples based on function signatures (if no other examples exist).

Group examples by function or by use case, whichever produces a more logical
flow. Start with the simplest example and build toward complex scenarios.

Include at least one example for each exported function. Include pipeline
examples if any function accepts pipeline input.

### troubleshooting

Generate a troubleshooting guide with symptom-based sections:

- **Module import failures** —
  - Symptom: "The specified module was not found" or "could not be loaded."
  - Causes: module not installed, wrong path, missing dependencies.
  - Diagnostic: `Get-Module -ListAvailable`, `$env:PSModulePath`.
  - Resolution: installation steps, path verification.

- **Execution policy errors** —
  - Symptom: "cannot be loaded because running scripts is disabled."
  - Cause: execution policy prevents script execution.
  - Diagnostic: `Get-ExecutionPolicy -List`.
  - Resolution: `Set-ExecutionPolicy` with appropriate scope.

- **Parameter validation errors** —
  - Symptom: "Cannot validate argument on parameter."
  - Causes: invalid value for `ValidateSet`, out of range for `ValidateRange`,
    null for `ValidateNotNullOrEmpty`.
  - Diagnostic: review the function help for accepted values.
  - Resolution: provide valid parameter values. List the specific validation
    constraints found in the module's functions.

- **Permission errors** —
  - Symptom: "Access denied" or "insufficient permissions."
  - Causes: function requires elevation, specific AD group membership, or
    delegation.
  - Diagnostic: `whoami /groups`, check `#Requires -RunAsAdministrator`.
  - Resolution: run as administrator, verify group membership.
  - Include only if functions require elevation.

- **Dependency module errors** —
  - Symptom: "The specified module was not loaded because no valid module file
    was found."
  - Cause: required module not installed or wrong version.
  - Diagnostic: `Get-Module -ListAvailable <DependencyName>`.
  - Resolution: install the required module with the correct version.
  - Include only if the manifest specifies `RequiredModules`.

- **Pipeline input errors** —
  - Symptom: "The input object cannot be bound to any parameters" or unexpected
    results from pipeline.
  - Cause: wrong property names for `ValueFromPipelineByPropertyName`, wrong
    object type for `ValueFromPipeline`.
  - Diagnostic: `Get-Member` on the input object, review parameter bindings.
  - Resolution: verify input object properties match expected parameter names.
  - Include only if functions accept pipeline input.

- **Credential and authentication errors** —
  - Symptom: authentication failures when passing credentials.
  - Cause: wrong credential format, expired password, insufficient rights.
  - Diagnostic: test credential with `Test-Connection` or equivalent.
  - Resolution: recreate credential object, verify account status.
  - Include only if functions accept `[PSCredential]` parameters.

For each section, use this structure:
1. **Symptom** — The error message or observable behavior.
2. **Cause** — Why this happens.
3. **Diagnostic steps** — Commands to investigate.
4. **Resolution** — Numbered steps to fix it.

Tailor all sections to the specific patterns found in the scanned module. Do not
include troubleshooting for scenarios that are not applicable.

## Module boundary detection

A PowerShell module is a directory containing a `.psm1` (module file) or `.psd1`
(module manifest) file.

Discovery rules:

1. The root target directory is always treated as the primary module if it
   contains a `.psm1` or `.psd1` file.
2. If the root directory does not contain a `.psm1` or `.psd1` file, look one
   level deeper for a directory that does (common pattern: `src/<ModuleName>/`).
3. Nested modules: subdirectories under `Modules/` or `NestedModules/` that
   contain their own `.psm1` file are separate modules.
4. The module name is derived from the `.psd1` file's `RootModule` or
   `ModuleToProcess` field, or from the directory name if not specified.
5. Ignore directories named `output/`, `bin/`, `obj/`, `.git/`, `node_modules/`,
   `TestResults/`, `.vscode/`.

To discover modules, run:
```
find <target> -name "*.psm1" -o -name "*.psd1" | grep -v -E "(output|bin|obj|\.git|node_modules|TestResults)/"
```

Group results by directory. Each directory with a `.psm1` or `.psd1` file is a
module boundary. The module name is the directory name.

Function directories within a module are not separate modules. `Public/`,
`Private/`, and `Functions/` are parts of the parent module.
