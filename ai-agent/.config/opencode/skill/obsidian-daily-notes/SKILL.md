---
name: obsidian-daily-notes
description: >
  Create or update the user's Obsidian daily note for today (or any specific date)
  based on the current conversation context. Use this skill whenever the user wants
  to record, log, summarize, or save what was accomplished into their daily note.
  Triggers on phrases like: "create a daily note about X", "create today's daily
  note", "log this to my daily note", "add this to today's journal", "save this to
  my notes", "we finished working, create the daily note", "summarize today into my
  notes", "update my daily note", "log what we did today", "write today's reflection".
  Also use proactively at the natural end of a meaningful work session — ask the
  user if they'd like to capture what we did into the daily note.
---

# Obsidian Daily Notes Skill

Create or append to the user's Obsidian daily note for a specific date. The user keeps daily notes following a strict structure — this skill writes into that structure correctly without breaking the template.

## Vault paths

**Vault root:** `/home/sohaib/Dropbox/Notes/Obsidian Vault/`

**Daily notes folder:** `Work/Notes/dailies/YYYY/MM MMMM/`
- `YYYY` = 4-digit year (e.g. `2026`)
- `MM MMMM` = zero-padded month number + space + full month name (e.g. `05 May`, `12 December`)

**Filename format:** `YYYY-MM-DD dddd.md`
- e.g. `2026-05-21 Thursday.md`, `2026-12-31 Thursday.md`

**Full example path for today:**
`/home/sohaib/Dropbox/Notes/Obsidian Vault/Work/Notes/dailies/2026/05 May/2026-05-21 Thursday.md`

**Template reference:** `/home/sohaib/Dropbox/Notes/Obsidian Vault/Work/templates/daily.md`

## Daily note structure

Every daily note MUST follow this exact structure (this is the user's template — don't deviate):

```markdown
---
date: YYYY-MM-DD
day: Dddd
tags:
  - daily
---

# YYYY-MM-DD Dddd

## 🎯 Today's goal
> The one thing I want to accomplish today.

- <one main goal>

## ✅ Tasks today
- [ ] <pending task>
- [x] <completed task>

## 📝 Log / journal
*Decisions, ideas, what happened, links to other notes…*

- <bullet-style log entries>

## 🌙 Reflection (end of day)
**Wins:**
- <what went well>

**Lessons / improve:**
- <what to do better>
```

## Steps when invoked

### 1. Determine target date
- Default: today (use the current date from the conversation context)
- If user says "yesterday" / "Monday" / "May 19" → resolve accordingly
- Convert to: `YYYY-MM-DD`, day name (Monday/Tuesday/...), month name (May, June, ...), folder path

### 2. Check if the file exists
```bash
ls "/home/sohaib/Dropbox/Notes/Obsidian Vault/Work/Notes/dailies/YYYY/MM MMMM/YYYY-MM-DD dddd.md"
```

### 3a. If file does NOT exist — create it
- Use `mkdir -p` to ensure the year/month folders exist
- Write the full template structure with frontmatter, replacing placeholders with actual values
- Fill the sections based on conversation context (see "Populating sections" below)

### 3b. If file EXISTS — append/update intelligently
- READ the file first (always)
- Identify which section the new content belongs in
- Append bullets to that section without disturbing other sections
- Use the Edit tool to insert in the right place, OR Read+Write the full file
- Preserve all existing content (frontmatter, other sections, completed checkboxes)

### 4. Confirm to the user
- "Created daily note for **Thursday, May 21, 2026**" (when new)
- "Added to today's **Log / journal** section" (when appending)
- Include the path so the user can verify

## Populating sections from conversation context

When auto-filling from what we just discussed, here's how to map conversation → sections:

| Section | What goes here |
|---|---|
| **🎯 Today's goal** | The main thing the user set out to do at the start of the session. ONE bullet, not many. If unclear, ask. |
| **✅ Tasks today** | Concrete things accomplished — use `- [x]` for done, `- [ ]` for still pending. Phrase as past-tense actions ("Installed X", "Fixed Y"). |
| **📝 Log / journal** | Decisions made, problems solved, key findings, wiki-links to relevant notes (`[[Other Note]]`). Bullet style, terse. |
| **🌙 Reflection** | Only fill if user asks for end-of-day reflection. Wins = what went well. Lessons = what to do differently. |

Be terse. Each bullet should be one sentence or less. Avoid corporate fluff. Use the user's voice (direct, technical).

## Wiki-link conventions

When referencing other notes in the daily, use Obsidian wiki-link syntax:
- `[[Android Studio on Vocallremote]]` — link to a specific note
- `[[architecture#Section]]` — link to a section
- `[[2026-05-20 Wednesday]]` — link to another daily note

Obsidian resolves these by filename automatically (no full path needed) as long as filenames are unique.

## Frontmatter format

Always include the frontmatter exactly like this — the calendar plugin and tag-based queries depend on it:

```yaml
---
date: 2026-05-21
day: Thursday
tags:
  - daily
---
```

- `date` is unquoted ISO format
- `day` is the full English day name, capitalized
- `tags` is a list under `- daily` (lowercase, no `#`)

## Things to NEVER do

- ❌ Don't change section headers (`## 🎯 Today's goal`, etc.) — the user relies on these for visual scanning
- ❌ Don't remove emojis from section headers
- ❌ Don't merge sections together
- ❌ Don't add new top-level sections without asking
- ❌ Don't overwrite existing content when appending — always READ first
- ❌ Don't put work notes in the wrong vault — daily notes ONLY go under `Work/Notes/dailies/`
- ❌ Don't ask the user where to save it — the path is deterministic from the date

## Example invocations

### Example 1 — End of work session, create new daily

> User: "okay we're done. create today's daily note with what we did"

Action: Create `Work/Notes/dailies/2026/05 May/2026-05-21 Thursday.md` with frontmatter + populated sections summarizing the session.

### Example 2 — Add a bullet to existing log

> User: "log to today's note: 'fixed the SSL cert renewal hook'"

Action: Read existing file, append `- Fixed the SSL cert renewal hook` to the `## 📝 Log / journal` section. Don't touch goal, tasks, or reflection.

### Example 3 — Mark a task done

> User: "mark 'install android studio' as done in today's note"

Action: Read existing file, find that bullet in `## ✅ Tasks today`, change `- [ ]` to `- [x]`. Leave the bullet text intact.

### Example 4 — Past day

> User: "add to yesterday's daily note: ..."

Action: Compute yesterday's date, build path, READ if exists or CREATE if not. Same rules.

## Sanity checks before writing

1. Confirm the YYYY/MM MMMM/ folder exists (create with `mkdir -p` if not)
2. Confirm filename matches `YYYY-MM-DD dddd.md` (with the full English day name)
3. Confirm frontmatter is valid YAML
4. Confirm section headers haven't been altered
5. Confirm any wiki-links use filenames that actually exist (do a quick `find` if uncertain)
