---
allowed-tools: Read, Bash(find:*), Bash(ls:*)
description: Audit markdown documentation against the IBM Documentation Style Guide. Reports findings with severity; use --fix to propose rewrites.
argument-hint: <file-or-directory> [--fix]
---

Audit the specified file or directory against the IBM Documentation Style Guide.

**Before anything else**, read the IBM documentation style reference at
`~/.claude/references/ibm-documentation-style.md` (honor `$CLAUDE_CONFIG_DIR`
if set). Its rules and severity taxonomy are **binding** for every finding below.

## Procedure

1. **Load the reference.** Read `~/.claude/references/ibm-documentation-style.md`
   in full. Every rule in that file applies.

2. **Identify target files.**
   - If the argument is a single `.md` file, audit that file.
   - If the argument is a directory, find all `.md` files in it (non-recursive
     by default; add `--recursive` to include subdirectories).
   - If no argument is given, audit all `.md` files in the current directory.

3. **Audit each file.** For every target file:
   a. Read the file in full.
   b. Check it against **every section** of the IBM style reference (voice and
      tone, sentence structure, word choice, headings, lists, tables,
      procedures, links, abbreviations, accessibility, code examples,
      punctuation, formatting, inclusive language, document structure).
   c. Record each violation with its severity, location, and a concrete
      recommendation.

4. **Classify findings.** Use the severity taxonomy from the reference:
   - **blocking** — Violates a core IBM principle (passive voice throughout,
     wrong person, inaccessible content, factual inaccuracy).
   - **important** — Clear style violation (heading hierarchy skipped, Latin
     abbreviations, "click here" links, inconsistent terminology, missing
     lead-in for lists, non-parallel structure).
   - **nit** — Minor polish (sentence slightly over 20 words, minor formatting
     or punctuation inconsistency).

5. **Report findings.** Per file, list each finding in this format:

   ```
   <severity> <one-line description>
     where:  <file:line or file:section>
     fix:    <concrete recommendation or rewrite>
   ```

   End with a summary: total files audited, findings by severity.

6. **If `--fix` is specified:** After the report, propose a rewrite for each
   finding. Show the original text and the corrected text side by side. **Do not
   apply changes automatically** — present them for approval (propose before
   write).

## What is NOT a finding

- Pre-existing style in files not targeted by this audit.
- Style choices that contradict an explicit project convention in CLAUDE.md
  (project rules override style guide).
- Formatting handled by linters or CI (trailing whitespace, line length in code
  blocks).
- Opinion-level disagreements where the existing text is defensible under IBM
  style.

## Output example

```
## doc-style audit: README.md

blocking  Passive voice throughout the introduction section.
  where:  README.md:1-8
  fix:    Rewrite "The configuration is loaded by the agent" as
          "The agent loads the configuration."

important  Latin abbreviation "e.g." used without spelling out.
  where:  README.md:23
  fix:    Replace "e.g." with "for example."

nit  Sentence exceeds 20 words (24 words).
  where:  README.md:35
  fix:    Split into two sentences at the conjunction.

---
Audited 1 file. Found 3 findings: 1 blocking, 1 important, 1 nit.
```
