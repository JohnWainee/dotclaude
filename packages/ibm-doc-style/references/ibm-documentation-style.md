# IBM Documentation Style Reference

Actionable checklist distilled from the IBM Style Guide. Use this reference
when auditing or writing markdown documentation. Each section lists concrete
rules with correct and incorrect examples.

> Loaded by `/doc-style` and by the `/review-pr` documentation agent.
> Not embedded in CLAUDE.md — kept here to minimize per-session token cost.

---

## 1. Voice and tone

Write with confidence. Address the reader directly. Avoid marketing language,
humor, and filler.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Use active voice. | "The script creates a log file." | "A log file is created by the script." |
| Use present tense. | "The command returns an exit code." | "The command will return an exit code." |
| Address the reader as "you." | "You can configure the timeout." | "The user can configure the timeout." / "One can configure the timeout." |
| State facts directly. Do not hedge. | "This command deletes the file." | "This command should delete the file." / "This command might delete the file." |
| Do not use first person ("I," "we") in technical prose. | "The API accepts JSON input." | "We designed the API to accept JSON input." |
| Avoid exclamation marks. | "The update is complete." | "The update is complete!" |
| Avoid anthropomorphizing software. | "The system detects a conflict." | "The system thinks there is a conflict." |

---

## 2. Sentence structure

Keep sentences short and focused. Each sentence carries one idea.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Aim for 20 words or fewer per sentence. | "Run the installer. It creates the configuration directory." | "Run the installer, which creates the configuration directory and sets the default values for all required parameters." |
| One idea per sentence. | "Save the file. Then restart the service." | "Save the file and then restart the service so the changes take effect." |
| Use parallel structure in compound elements. | "The tool reads, validates, and writes the configuration." | "The tool reads the config, then it does validation, and writes it out." |
| Lead with the condition in conditional sentences. | "If the file exists, the script skips the download." | "The script skips the download if the file exists." |
| Avoid noun strings longer than three words. | "Error log rotation policy" (3) | "Default error log file rotation policy configuration" (7) |

---

## 3. Word choice and terminology

Use the simplest word that conveys the meaning. Be consistent.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Choose simple words over complex synonyms. | "use" | "utilize" / "leverage" |
| | "start" | "initiate" / "commence" |
| | "end" | "terminate" / "finalize" |
| | "show" | "display" / "render" (unless technically precise) |
| | "about" | "approximately" / "roughly" |
| Write out Latin abbreviations. | "for example" | "e.g." |
| | "that is" | "i.e." |
| | "and so on" | "etc." |
| | "through" or "by using" | "via" |
| Use one term per concept throughout a document. | Always "server" (not sometimes "host," sometimes "machine"). | Switching between "server," "host," "machine," and "box." |
| Define a term on first use if the audience might not know it. | "The runbook (a step-by-step operations guide) covers..." | "The runbook covers..." (no definition, unfamiliar audience). |
| Avoid slang, idioms, and culturally specific expressions. | "This simplifies the process." | "This is a piece of cake." / "This is a no-brainer." |

---

## 4. Headings

Headings tell the reader what a section accomplishes. Make them task-oriented
and scannable.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Use sentence case (capitalize only the first word and proper nouns). | "Configure the firewall rules" | "Configure The Firewall Rules" / "CONFIGURE THE FIREWALL RULES" |
| Start with a verb (imperative) or gerund for task topics. | "Install the agent" / "Installing the agent" | "Agent installation" / "The agent" |
| Use noun phrases for concept and reference topics. | "Firewall rule syntax" | "About firewall rules" / "Understanding firewall rules" |
| Keep headings parallel within the same level. | H2: "Install the agent" / H2: "Configure the agent" / H2: "Verify the agent" | H2: "Installing" / H2: "Configuration" / H2: "How to verify" |
| Do not skip heading levels (for example, H2 to H4). | H1 then H2 then H3 | H1 then H3 (skipping H2) |
| Do not end headings with punctuation. | "Set the timeout value" | "Set the timeout value." / "Set the timeout value:" |

---

## 5. Lists

Use lists to break up dense information. Keep list items parallel.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Introduce every list with a lead-in sentence or clause. | "The package includes the following components:" | (List starts with no introduction.) |
| Use bulleted lists for unordered items. | Bullet list of supported platforms. | Numbered list of platforms (order does not matter). |
| Use numbered lists only for sequential steps. | Numbered steps for an installation procedure. | Numbered list of features. |
| Keep items grammatically parallel. | "- Create the directory" / "- Copy the files" / "- Set the permissions" | "- Create the directory" / "- Files should be copied" / "- Setting permissions" |
| End each item with a period if any item is a complete sentence. | All items end with periods. | Mixed: some with periods, some without. |
| End each item with no punctuation if all items are fragments. | "- Port 443" / "- Port 80" / "- Port 22" | "- Port 443." / "- Port 80" / "- Port 22." |
| Capitalize the first word of each item. | "- Run the command" | "- run the command" |
| Limit nested lists to two levels. | One level of sub-bullets. | Three or more levels of nesting. |

---

## 6. Tables

Use tables for structured data with two or more columns. Do not use tables for
layout or for content that fits better as a list.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Use sentence case for column headers. | "Parameter name" | "Parameter Name" / "PARAMETER NAME" |
| Left-align text columns. Right-align numeric columns. | Text left, numbers right. | All columns centered. |
| Do not leave cells empty; use "N/A" or a dash. | "N/A" or "—" | (Blank cell.) |
| Keep cell content concise; avoid full paragraphs in cells. | One sentence or a short phrase per cell. | Multi-paragraph content in a cell. |
| Add a table title or introductory sentence. | "Table 1 lists the supported parameters." | (Table appears with no introduction.) |

---

## 7. Procedures and steps

Write procedures so the reader can follow them without re-reading.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Use numbered steps for sequential actions. | "1. Open the file. 2. Add the entry. 3. Save the file." | Bullet list for sequential actions. |
| Write one action per step. | "1. Open the file." / "2. Add the entry." | "1. Open the file and add the entry." |
| Use imperative mood (command form). | "Run the following command:" | "You should run the following command:" / "The following command needs to be run:" |
| State the action before the result. | "Run the command. The output displays the version." | "To see the version, which is displayed when you run the command, type:" |
| State the location before the action when relevant. | "In the configuration file, add the following line:" | "Add the following line in the configuration file:" |
| Use "following" to introduce examples or code blocks. | "Run the following command:" | "Run this command:" / "Run the below command:" |

---

## 8. Links and cross-references

Make every link self-describing. The reader should know what they get before
they click.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Use descriptive link text. | "See [Configure the firewall](url)." | "See [here](url)." / "[Click here](url) to configure." |
| Do not use "click here," "this link," or bare URLs as link text. | "[IBM Documentation Style Guide](url)" | "https://example.com/ibm-style" (bare URL as link text) |
| Use title case when referencing a document by its title. | "See the *IBM Documentation Style Guide*." | "See the *ibm documentation style guide*." |
| Be specific about what the link leads to. | "For syntax details, see [Parameter reference](url)." | "For more information, see [here](url)." |

---

## 9. Abbreviations and acronyms

Spell out every abbreviation on first use. Do not assume the reader knows it.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Spell out on first use, abbreviation in parentheses. | "Application Programming Interface (API)" | "API" (first mention, never spelled out). |
| After the first use, use only the abbreviation. | First: "Transport Layer Security (TLS)." Later: "TLS." | Alternating between "TLS" and "Transport Layer Security" after the first use. |
| Do not create abbreviations for terms used only once or twice. | "the configuration file" (used twice) | "the configuration file (CF)" (unnecessary abbreviation). |
| Do not abbreviate common words. | "information" | "info" |
| | "application" | "app" (unless it is a proper name) |
| | "repository" | "repo" (unless the audience universally uses it) |

---

## 10. Accessibility

Write so that every reader can use the documentation, regardless of how they
access it.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Provide alt text for every image. | `![Diagram showing the data flow from client to server](image.png)` | `![](image.png)` or `![screenshot](image.png)` |
| Do not rely on color alone to convey meaning. | "Required fields are marked with an asterisk (*)." | "Required fields are in red." |
| Use meaningful link text (see section 8). | "[Installation guide](url)" | "[Link](url)" |
| Use semantic markup (headings, lists, code blocks). | `## Install the agent` as a real heading. | **Install the agent** (bold text pretending to be a heading). |
| Do not use directional language that assumes visual layout. | "In the following table" / "In the preceding section" | "In the table on the right" / "See below" |

---

## 11. Code examples

Show the reader working code. Annotate just enough to explain intent.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Make examples complete and runnable when possible. | A full command with expected output. | A fragment that cannot run without unstated context. |
| Use fenced code blocks with a language identifier. | ` ```bash ` | ` ``` ` (no language identifier) |
| Show expected output separately or inline. | "Output:" followed by a code block. | Output mixed into the same block as the command. |
| Use placeholder names that are obviously not real. | `example.com`, `your-project`, `<username>` | `myserver.internal.corp` (could look real). |
| Annotate sparingly — one short comment per non-obvious line. | `# Redirect stderr to the log file` | A comment on every line restating what the code does. |

---

## 12. Punctuation

Punctuate consistently. When in doubt, use the serial comma and a period.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Use the serial (Oxford) comma. | "logs, metrics, and traces" | "logs, metrics and traces" |
| End complete sentences with a period, including in lists. | "- The agent starts automatically." | "- The agent starts automatically" (no period on a full sentence). |
| Do not use exclamation marks in technical writing. | "The installation is complete." | "The installation is complete!" |
| Use an em dash (—) for parenthetical asides; do not pad with spaces. | "The default—port 443—is sufficient." | "The default - port 443 - is sufficient." / "The default -- port 443 -- is sufficient." |
| Use curly quotes only if the publishing system supports them; otherwise use straight quotes. | Straight quotes in markdown: `"value"` | Mixing curly and straight quotes. |
| Hyphenate compound modifiers before a noun. | "well-known port" / "command-line tool" | "well known port" / "command line tool" |
| Do not hyphenate after an adverb ending in "-ly." | "commonly used format" | "commonly-used format" |

---

## 13. Formatting conventions

Use formatting to distinguish types of content. Do not use it for emphasis
alone.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Bold for UI elements. | Click **Save**. | Click "Save." / Click *Save*. |
| Monospace for code, commands, filenames, and paths. | Run `npm install`. | Run "npm install". / Run *npm install*. |
| Monospace for parameter names, return values, and error messages. | The `timeout` parameter defaults to 30. | The *timeout* parameter defaults to 30. |
| Italic for introducing a new term (first occurrence only). | An *idempotent* operation produces the same result regardless of how many times you run it. | An *idempotent* operation... (still italic on second use). |
| Do not use all caps for emphasis. | "This step is required." (Bold if needed: "This step is **required**.") | "This step is REQUIRED." |
| Do not underline text (underlines imply hyperlinks). | **Important:** Back up first. | <u>Important:</u> Back up first. |

---

## 14. Inclusive language

Write for a global, diverse audience.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Use gender-neutral pronouns. | "they," "the user," or rephrase. | "he," "she," "he or she." |
| Use inclusive terms for technical concepts. | "primary / replica" or "main / secondary" | "master / slave" |
| | "allowlist / denylist" | "whitelist / blacklist" |
| Avoid culturally specific idioms and metaphors. | "This is straightforward." | "This is a slam dunk." / "This is low-hanging fruit." |
| Use person-first language when referring to people. | "users who need accessibility features" | "disabled users" |
| Avoid terms that trivialize complexity. | "Complete these steps to configure the service." | "Simply configure the service." / "Just run the command." |

---

## 15. Document structure

Organize content around what the reader needs to do, not around product
features or internal architecture.

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Follow the progression: overview, concepts, tasks, reference. | 1. What is it? 2. Key concepts. 3. How to install/configure/use. 4. Parameter reference. | Jumping between tasks and concepts with no structure. |
| Lead with the most common task or the critical path. | Installation before advanced configuration. | Alphabetical listing of all features. |
| Put prerequisites at the start of a task topic, not inline. | "Before you begin:" section before the steps. | "Make sure you have X" buried in step 5. |
| Use consistent section ordering across similar documents. | Every runbook follows: Purpose, Prerequisites, Steps, Verification, Troubleshooting. | Each runbook has a different section order. |
| Keep reference material (flags, parameters, return codes) in tables, not prose. | A parameter table with name, type, default, and description columns. | Paragraphs describing each parameter one by one. |

---

## Severity taxonomy (for `/doc-style` and `/review-pr` auditing)

When auditing documentation, classify each finding:

- **blocking** — Violates a core IBM principle: passive voice throughout, wrong
  person ("the user" instead of "you"), inaccessible content (no alt text,
  color-dependent meaning), or factual inaccuracy.
- **important** — Clear style violation: heading hierarchy skipped, Latin
  abbreviations used, "click here" links, inconsistent terminology, missing
  lead-in for lists, non-parallel structure.
- **nit** — Minor polish: sentence slightly over 20 words, could be more
  parallel, formatting inconsistency, minor punctuation issue.

Report only findings you can defend with a specific location and a concrete
recommendation. Do not manufacture findings to appear thorough.
