# review-pr integration — IBM Documentation Style agent

Add the following agent to your `/review-pr` command's parallel review step
(typically step 4). This agent audits markdown files changed in the PR against
the IBM Documentation Style Guide.

## Where to insert

In your `commands/review-pr.md`, find the step that launches parallel review
agents (for example, "launch 5 parallel Sonnet agents"). Add this as an
additional agent and update the count.

## Agent text

```
f. Agent #6: Check whether the PR modifies any markdown documentation files
   (.md). If none were changed, return "no documentation files in diff —
   skipped" and stop. If markdown files were changed, read the IBM
   documentation style reference at
   ~/.claude/references/ibm-documentation-style.md (honor $CLAUDE_CONFIG_DIR
   if set) and audit each changed document against it. Apply the reference's
   severity taxonomy (blocking / important / nit). For each finding, return:
   the severity, a one-line description, the file and location, and a
   concrete fix recommendation. Apply the same confidence-gating rules as
   the other agents.
```

## False-positive addition

Add the following to your false-positive examples list:

```
- Style preferences that contradict an explicit project convention in CLAUDE.md
```
