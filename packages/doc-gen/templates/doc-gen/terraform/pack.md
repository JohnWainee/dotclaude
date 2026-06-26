---
name: Terraform
description: >
  Documentation for Terraform configurations — module references, variable
  catalogs, state management runbooks, and troubleshooting guides.
detect:
  - { pattern: "*.tf", weight: 3 }
  - { pattern: ".terraform.lock.hcl", weight: 3 }
  - { pattern: "terraform.tfvars", weight: 2 }
  - { pattern: "backend.tf", weight: 2 }
  - { pattern: "*.tf.json", weight: 2 }
  - { pattern: "*.tfvars", weight: 1 }
min-confidence: 3
doc-types:
  - { id: "project-readme", name: "Project documentation overview", output-path: "docs/README.md", scope: "per-repo" }
  - { id: "module-readme", name: "Module reference", output-path: "docs/modules/{module}/README.md", scope: "per-module" }
  - { id: "variable-reference", name: "Variable reference", output-path: "docs/modules/{module}/variables.md", scope: "per-module" }
  - { id: "output-reference", name: "Output reference", output-path: "docs/modules/{module}/outputs.md", scope: "per-module" }
  - { id: "state-runbook", name: "State management runbook", output-path: "docs/runbooks/state-management.md", scope: "per-repo" }
  - { id: "troubleshooting", name: "Troubleshooting guide", output-path: "docs/troubleshooting/terraform.md", scope: "per-repo" }
---

## Context gathering

### project-readme

Read the root `main.tf` (or all root-level `*.tf` files) to understand the
overall configuration structure. Identify the provider blocks, backend
configuration, and top-level module calls. Read any existing `README.md` in the
root directory for context to preserve.

### module-readme

Read all `*.tf` files in the module directory. Extract:
- Resource types and their names (from `resource` blocks).
- Data sources (from `data` blocks).
- Module calls (from `module` blocks) and their sources.
- Provider requirements (from `required_providers` blocks).
- Any local values (from `locals` blocks) that clarify the module's purpose.

Read any existing `README.md` in the module directory for context to preserve.

### variable-reference

Read `variables.tf` in the module directory. If `variables.tf` does not exist,
read all `*.tf` files and extract `variable` blocks. For each variable, extract:
- Name.
- Type constraint.
- Default value (if any).
- Description (if any).
- Validation rules (if any).

### output-reference

Read `outputs.tf` in the module directory. If `outputs.tf` does not exist, read
all `*.tf` files and extract `output` blocks. For each output, extract:
- Name.
- Value expression.
- Description (if any).
- Sensitive flag (if set).

### state-runbook

Read `backend.tf` or backend configuration in the root `main.tf`. Identify:
- Backend type (S3, azurerm, gcs, local, remote, and others).
- Bucket, key, region, or equivalent settings.
- State locking configuration (DynamoDB table, and others).

Read `terraform.tfvars` and any `*.auto.tfvars` files for environment-specific
configuration.

### troubleshooting

Scan all `*.tf` files for patterns that commonly cause issues:
- Provider blocks (authentication configuration).
- Module sources (registry, git, local paths).
- Backend configuration.
- Complex expressions (for_each, count, dynamic blocks).
- Provisioners (if any).

## Generation instructions

Follow the IBM Documentation Style Guide at
`~/.claude/references/ibm-documentation-style.md` for all generated content.

### project-readme

Generate a project documentation overview with these sections:

- **Overview** — One to two paragraphs describing what this Terraform
  configuration provisions and why.
- **Architecture** — What infrastructure components does this configuration
  manage? List the top-level resources and modules.
- **Prerequisites** — What you need before running this configuration (provider
  credentials, existing infrastructure, required tool versions).
- **Quick start** — Numbered steps: clone, configure variables, init, plan,
  apply.
- **Module index** — Table linking to each module's reference documentation in
  `docs/modules/`. Columns: Module, Purpose, Link.
- **Additional documentation** — Links to runbooks and troubleshooting guides in
  `docs/`.

### module-readme

Generate a module reference document with these sections:

- **Purpose** — One paragraph describing what this module provisions and when you
  would use it.
- **Resources** — Table of all resources this module creates. Columns: Resource
  type, Resource name, Purpose.
- **Dependencies** — What must exist before you apply this module (for example,
  VPC, IAM roles, other modules). List module calls with their sources.
- **Usage example** — A complete `module` block showing how to call this module
  with required and commonly used optional variables.
- **Inputs** — Summary table linking to `variables.md`. Columns: Name, Type,
  Required, Description.
- **Outputs** — Summary table linking to `outputs.md`. Columns: Name,
  Description.

### variable-reference

Generate a variable reference document:

- **Title:** "Variables for {module name}"
- **Format:** One table per logical group. Group variables by purpose if grouping
  is apparent from naming conventions or comments (for example, networking,
  compute, tags, and others). If no grouping is apparent, use a single table.
- **Table columns:** Name, Type, Default, Required, Description.
- **Required column:** "Yes" if no default is set, "No" otherwise.
- **Validation section:** After the table, list any variables with validation
  rules. For each, describe what values are accepted and the error message.

### output-reference

Generate an output reference document:

- **Title:** "Outputs for {module name}"
- **Format:** Single table.
- **Table columns:** Name, Description, Sensitive.
- **Sensitive column:** "Yes" if the `sensitive` flag is set, "No" otherwise.
- After the table, add notes for any outputs that reference complex expressions
  or other module outputs.

### state-runbook

Generate a state management runbook with these sections:

- **Purpose** — Explain why state management matters for this configuration.
- **Backend configuration** — Document the actual backend type and settings from
  the codebase. Include the relevant configuration block.
- **Initialize state** — Numbered steps to run `terraform init` with the backend.
- **Migrate state between backends** — Steps to migrate state (for example, from
  local to S3). Include the `terraform init -migrate-state` command.
- **Import existing resources** — Steps to import a resource into state. Include
  the `terraform import` command syntax with an example using an actual resource
  type from the codebase.
- **Move resources in state** — Steps to use `terraform state mv`. Include
  common scenarios (rename, move to a module).
- **Recover from state corruption** — Steps to pull state, back it up, and
  force-unlock.
- **State locking** — Document the locking mechanism. Include steps to
  force-unlock if a lock is stuck.

Use numbered steps for all procedures. One action per step. Imperative mood.

### troubleshooting

Generate a troubleshooting guide with symptom-based sections:

- **Provider authentication failures** — Symptoms, causes, and resolution for the
  specific providers found in the codebase.
- **State lock errors** — Symptoms: "Error acquiring the state lock." Cause and
  resolution.
- **Plan and apply drift** — Symptoms: unexpected changes on plan. Causes
  (manual changes, provider updates) and resolution.
- **Module version conflicts** — Symptoms and resolution for version constraint
  issues.
- **Dependency cycles** — Symptoms: "Cycle" error. How to identify and break
  cycles.
- **Backend initialization failures** — Symptoms and resolution for the specific
  backend type in use.

For each section, use this structure:
1. **Symptom** — The error message or observable behavior.
2. **Cause** — Why this happens.
3. **Resolution** — Numbered steps to fix it.

Tailor all sections to the specific providers, backends, and module sources found
in the scanned codebase. Do not include generic troubleshooting for providers or
backends that are not present.

## Module boundary detection

A Terraform module is a directory containing at least one `*.tf` file with a
`resource`, `data`, or `module` block.

Discovery rules:
1. The root target directory is always treated as a module.
2. Any directory named `modules/` at any depth is a container for child modules.
   Each subdirectory of `modules/` is a separate module.
3. Any directory containing `main.tf` is a module boundary, regardless of its
   name or depth.
4. Ignore directories named `.terraform/`, `examples/`, and `.terragrunt-cache/`.
5. If a directory contains only variable or output definitions (no resource,
   data, or module blocks), it is not a module boundary.

To discover modules, run:
```
find <target> -name "*.tf" -not -path "*/.terraform/*" -not -path "*/examples/*" -not -path "*/.terragrunt-cache/*"
```

Group results by directory. Each directory with at least one `*.tf` file is a
candidate module. Verify candidates by checking for `resource`, `data`, or
`module` blocks (a lightweight content check limited to this verification step).
