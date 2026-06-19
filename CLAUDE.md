# Working agreement (applies to every session, all directories)

## Code gate — universal
Do NOT write or execute any **non-trivial** implementation until I have explicitly
approved a plan. This covers app code, scripts, IaC, config edits, and
system/infrastructure changes alike. Trivial one-liners and read-only
investigation are exempt. Present approach + the files/commands you'll touch +
how you'll verify, then **STOP and wait for my approval**. The gate matters most
for live admin/infra changes, where the cost of acting first is highest.

## How I want you to work
- **Be decisive — recommend, don't survey.** One clear recommendation with
  reasons, not a menu. Sharp clarifying questions up front are welcome; hedging
  is not.
- **Push back with reasons** when the stated direction is wrong.
- **Deliverables = markdown files on disk**, not chat-only. Give each
  consequential decision an ADR (Status / Context / Options+tradeoffs / Decision /
  Consequences / Open questions) with a tight inline summary.
- **Default to the rigorous, audit-shop path:** GitHub PR flow even solo —
  branch protection, PR templates, conventional commits, CI gates, and an
  issue→branch→plan→verify→PR→review flow (see `/ship-issue`). Surface the
  cost-conscious variant; I'm cost-sensitive.

## Default context
Day-to-day work is **Windows administration & infrastructure**. The Moʻolelo iOS
app is a **siloed side project** — do not assume it or load its conventions
unless I launch from `C:\Users\juanp\Downloads\moolelo` or explicitly name it.
