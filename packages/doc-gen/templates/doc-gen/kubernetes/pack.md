---
name: Kubernetes
description: >
  Documentation for Kubernetes manifests and Helm charts — workload references,
  deployment runbooks, and troubleshooting guides.
detect:
  - { pattern: "Chart.yaml", weight: 3 }
  - { pattern: "values.yaml", weight: 3 }
  - { pattern: "kustomization.yaml", weight: 3 }
  - { pattern: "kustomization.yml", weight: 3 }
  - { pattern: "skaffold.yaml", weight: 2 }
  - { pattern: "Dockerfile", weight: 1 }
  - { pattern: "*.yaml", weight: 1 }
  - { pattern: "*.yml", weight: 1 }
min-confidence: 3
doc-types:
  - { id: "project-readme", name: "Project documentation overview", output-path: "docs/README.md", scope: "per-repo" }
  - { id: "workload-reference", name: "Workload reference", output-path: "docs/modules/{workload}/README.md", scope: "per-module" }
  - { id: "helm-values", name: "Helm values reference", output-path: "docs/reference/helm-values.md", scope: "per-repo" }
  - { id: "deploy-runbook", name: "Deployment runbook", output-path: "docs/runbooks/deployment.md", scope: "per-repo" }
  - { id: "rollback-runbook", name: "Rollback runbook", output-path: "docs/runbooks/rollback.md", scope: "per-repo" }
  - { id: "troubleshooting", name: "Troubleshooting guide", output-path: "docs/troubleshooting/kubernetes.md", scope: "per-repo" }
---

## Context gathering

### project-readme

Read `Chart.yaml` (if Helm) or `kustomization.yaml` (if Kustomize) to understand
the project structure. Read any existing `README.md` for context to preserve.
Identify all workloads, services, and supporting resources.

### workload-reference

Read all YAML manifest files in the workload directory. For each manifest, parse
the `kind:` field to identify the resource type. Extract:
- Deployment or StatefulSet specification (replicas, strategy, selectors).
- Container images, tags, and pull policies.
- Ports (container ports, service ports).
- Environment variables (names and value sources — ConfigMap refs, Secret refs,
  field refs). Do not extract secret values.
- Volume mounts and volume definitions.
- Resource requests and limits (CPU, memory).
- Liveness, readiness, and startup probes.
- Init containers.
- Service accounts and RBAC bindings.

For Helm charts, also read the relevant section of `values.yaml` that configures
this workload.

### helm-values

Read `values.yaml` and `Chart.yaml`. For each top-level key in `values.yaml`,
extract:
- The key path (dot-notation for nested keys).
- The default value.
- The type (string, integer, boolean, object, list).

Read `templates/` files to understand how each value is used, which helps
generate accurate descriptions.

### deploy-runbook

Read deployment manifests to identify:
- Deployment strategy (RollingUpdate, Recreate).
- Namespace.
- Readiness and liveness probe configuration.
- Init containers and their purpose.
- Any ConfigMaps or Secrets referenced.

Look for CI/CD configuration files (`.github/workflows/`, `Jenkinsfile`,
`.gitlab-ci.yml`, `skaffold.yaml`) to understand the deployment pipeline.

### rollback-runbook

Read deployment manifests to extract:
- Deployment names and namespaces.
- Deployment strategy.
- Revision history limit.

Read any existing rollback procedures or runbooks for context to preserve.

### troubleshooting

Scan all YAML manifests for patterns that commonly cause issues:
- Resource requests and limits (potential OOMKill).
- Liveness and readiness probes (timing, endpoints).
- Volume mounts and PersistentVolumeClaim references.
- Secret and ConfigMap references (potential missing refs).
- Network policies.
- Ingress or Gateway API configurations.
- Image pull secrets.
- Node selectors, tolerations, and affinity rules.

## Generation instructions

Follow the IBM Documentation Style Guide at
`~/.claude/references/ibm-documentation-style.md` for all generated content.

### project-readme

Generate a project documentation overview with these sections:

- **Overview** — One to two paragraphs describing what this Kubernetes project
  deploys and its purpose.
- **Architecture** — What workloads, services, and supporting resources does this
  project contain? List the main components.
- **Prerequisites** — What you need before deploying (cluster access, namespaces,
  secrets, tool versions such as `kubectl`, `helm`, `kustomize`).
- **Quick start** — Numbered steps to deploy. Adapt to the project's tooling
  (Helm install, Kustomize build and apply, or plain kubectl apply).
- **Workload index** — Table linking to each workload's reference documentation.
  Columns: Workload, Kind, Purpose, Link.
- **Additional documentation** — Links to runbooks, values reference, and
  troubleshooting guides.

### workload-reference

Generate a workload reference document with these sections:

- **Purpose** — One paragraph describing what this workload does.
- **Resources** — Table of all Kubernetes resources in this workload. Columns:
  Name, Kind, Namespace.
- **Container specification** — For each container in the workload:
  - Image and tag.
  - Ports (container port, protocol).
  - Environment variables (name and source — do not include secret values).
  - Resource requests and limits.
  - Volume mounts.
- **Health checks** — Liveness, readiness, and startup probes with their
  configuration (path, port, timing).
- **Scaling** — HorizontalPodAutoscaler configuration if present. Static replica
  count otherwise.
- **Dependencies** — Services, ConfigMaps, Secrets, and PersistentVolumeClaims
  this workload references.
- **Configuration** — If this is a Helm chart, link to the values reference and
  list the key values that configure this workload.

### helm-values

Generate a Helm values reference document:

- **Title:** "Helm values reference"
- **Introduction** — One paragraph explaining how to override values (via
  `--set`, `-f values.yaml`, and others).
- **Format:** One table per top-level key in `values.yaml`. Each table documents
  the parameters under that key.
- **Table columns:** Parameter, Type, Default, Description.
- **Parameter column:** Use dot-notation for nested keys (for example,
  `replicaCount`, `image.repository`, `image.tag`).
- **Description column:** Derive from how the value is used in `templates/`. If a
  value controls a conditional (`if .Values.ingress.enabled`), note that it
  enables or disables the resource.
- After the tables, add a section listing any values that reference Secrets or
  require external configuration.

### deploy-runbook

Generate a deployment runbook with these sections:

- **Purpose** — Explain what this runbook covers and when to use it.
- **Prerequisites** — Cluster access, namespace creation, secrets, and tooling.
- **Pre-deployment checks** — Numbered steps to verify readiness (cluster
  connectivity, namespace exists, required secrets are present, image is
  available).
- **Deploy** — Numbered steps using the project's actual tooling and names:
  - Helm: `helm upgrade --install <release> <chart> -n <namespace> -f values.yaml`
  - Kustomize: `kubectl apply -k <directory>`
  - Plain manifests: `kubectl apply -f <directory> -n <namespace>`
- **Verify deployment** — Numbered steps to confirm success: check pod status,
  check rollout status, verify service endpoints, test connectivity.
- **Post-deployment validation** — Steps to verify the application is functioning
  (health check endpoints, smoke tests, log inspection).

Use numbered steps for all procedures. One action per step. Imperative mood.
Include actual resource names, namespaces, and commands derived from the
manifests.

### rollback-runbook

Generate a rollback runbook with these sections:

- **Purpose** — Explain when to use this runbook (deployment failures, degraded
  performance, broken functionality).
- **When to roll back** — Criteria for deciding to roll back versus fixing
  forward.
- **Rollback procedure** — Numbered steps:
  - Helm: `helm rollback <release> <revision> -n <namespace>`
  - kubectl: `kubectl rollout undo deployment/<name> -n <namespace>`
  - Include steps to check revision history first:
    `kubectl rollout history deployment/<name> -n <namespace>`
- **Verify rollback** — Numbered steps to confirm the rollback succeeded (pod
  status, rollout status, application health).
- **Escalation** — When to escalate and to whom (leave as a placeholder for the
  team to fill in).

Use actual deployment names and namespaces from the manifests.

### troubleshooting

Generate a troubleshooting guide with symptom-based sections:

- **CrashLoopBackOff** — Symptoms, common causes (application error, missing
  config, resource limits), diagnostic steps (`kubectl logs`, `kubectl describe
  pod`), resolution.
- **ImagePullBackOff** — Symptoms, causes (wrong image name, missing pull
  secret, registry auth), resolution.
- **OOMKilled** — Symptoms, causes (memory limits too low, memory leak),
  diagnostic steps, resolution. Tailor to the actual resource limits in the
  manifests.
- **Pods stuck in Pending** — Causes (insufficient resources, node selector
  mismatch, PVC binding), resolution.
- **Service discovery failures** — Symptoms (connection refused, DNS resolution
  failure), causes, resolution. Tailor to the actual services in the manifests.
- **Ingress not routing traffic** — Symptoms, causes (missing ingress class,
  wrong paths, TLS issues), resolution. Include only if ingress resources exist
  in the manifests.
- **PersistentVolumeClaim issues** — Symptoms (stuck in Pending), causes (no
  matching PV, storage class issues), resolution. Include only if PVCs exist in
  the manifests.
- **RBAC errors** — Symptoms (forbidden), causes (missing ClusterRole,
  ServiceAccount), resolution. Include only if RBAC resources exist in the
  manifests.

For each section, use this structure:
1. **Symptom** — The observable behavior or error message.
2. **Cause** — Why this happens.
3. **Diagnostic steps** — Commands to investigate.
4. **Resolution** — Numbered steps to fix it.

Tailor all sections to the specific resource types, namespaces, and
configurations found in the scanned manifests. Do not include troubleshooting for
resource types that are not present.

## Module boundary detection

A Kubernetes "workload" is the equivalent of a Terraform module. It represents a
logical grouping of related manifests.

Discovery rules:

### Helm charts
Each directory containing a `Chart.yaml` file is a workload boundary. The chart
name (from `Chart.yaml`) is the workload name. Subchart directories under
`charts/` are separate workloads.

### Kustomize
Each directory containing a `kustomization.yaml` or `kustomization.yml` file is a
workload boundary. The directory name is the workload name. Overlays (directories
under `overlays/` or `environments/`) are not separate workloads — they are
variants of the base.

### Plain manifests
Group manifests by directory. Each directory containing YAML files with
`kind: Deployment`, `kind: StatefulSet`, or `kind: DaemonSet` is a workload
boundary. The directory name is the workload name.

### Detection validation
Because `*.yaml` and `*.yml` have low detection weight (1), the Kubernetes pack
avoids false positives by requiring high-confidence signals (Chart.yaml,
kustomization.yaml) to meet the confidence threshold. If only generic YAML files
are found, validate that they contain Kubernetes API objects by checking for
`apiVersion:` and `kind:` fields before confirming the pack match.

To discover workloads, run:
```
find <target> -name "Chart.yaml" -o -name "kustomization.yaml" -o -name "kustomization.yml"
```

If no Helm or Kustomize markers are found, fall back to:
```
find <target> -name "*.yaml" -o -name "*.yml" | head -20
```

Then check a sample of matched files for `apiVersion:` and `kind:` fields.

Ignore directories named `node_modules/`, `.git/`, and `vendor/`.
