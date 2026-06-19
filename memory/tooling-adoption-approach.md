---
name: tooling-adoption-approach
description: "How to evaluate external agent tools/frameworks — cherry-pick into slim local versions, propose before installing."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3171ece4-aaf2-43fb-9eeb-39e6a4c0da10
---

When evaluating a third-party agent framework or tool (e.g. superpowers,
hivemind), do not adopt it wholesale. Extract the few good ideas and build a
slim, local version; drop heavyweight, cloud-dependent, or team-oriented
machinery.

**Why:** Solo builder, cost-sensitive, privacy-conscious. Team-propagation
features have zero value solo; cloud capture means data egress and recurring
cost; heavyweight infra fights the lean/trim economy modes. See [[user-profile]].

**How to apply:** Compare on layers, not features — name what gap the tool
fills vs. what's already covered. Recommend decisively. Build deliverables as
inert drafts (e.g. `*.DRAFT.md`), let the user review, install only on explicit
approval — never auto-install. Mirrors the code-gate discipline in
[[moolelo-working-style]].
