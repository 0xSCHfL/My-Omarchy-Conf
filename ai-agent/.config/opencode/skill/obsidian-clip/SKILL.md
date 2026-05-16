---
name: obsidian-clip
description: >
  Save a web page, article, cheatsheet, or any online resource as a clipping
  note in Obsidian with proper frontmatter metadata (title, source URL, author,
  created date, tags). Use whenever the user wants to save something from the web
  to their Obsidian vault. Triggers on: "save this to obsidian", "clip this page",
  "add this to my notes", "save this cheatsheet", "save this article", pasting a
  URL or web content and asking to save it. Always create a proper clipping note —
  never just dump raw content.
---

# Obsidian Clip Skill

Save web content as a properly formatted Obsidian clipping note with frontmatter metadata.

## Vault paths

| Vault | Clippings folder |
|-------|-----------------|
| Studying (career/technical) | `/home/sohaib/Dropbox/Notes/Obsidian Vault/Studying/Clippings/` |
| Live_Style (personal) | `/home/sohaib/Dropbox/Notes/Obsidian Vault/Live_Style/Clippings/` |

Default to **Studying/Clippings/** for technical content (security, networking, programming, CTF, Linux).  
Use **Live_Style/Clippings/** for personal content (language learning, lifestyle, music, etc.).  
If unsure, ask the user.

## Frontmatter format

Every clipping must start with this frontmatter block:

```markdown
---
title: "Page or article title"
source: "https://original-url.com"
author: Author name (leave blank if unknown)
published: YYYY-MM-DD (leave blank if unknown)
created: 2026-05-03
description: "One sentence about what this is"
tags:
  - clippings
  - relevant-tag
  - another-tag
---
```

**Rules for tags:**
- Always include `clippings`
- Add topic tags based on content: `pentest`, `ctf`, `oscp`, `networking`, `linux`, `programming`, `security`, `windows`, `ad`, etc.
- Keep tags lowercase with hyphens

## File naming

`Title Of The Page.md` — use the page title, clean any special characters.

Example: `OSEP Advanced Cheatsheet v3.md`, `Networking Interview Questions.md`

## Content formatting

After the frontmatter, format the content clearly in markdown:
- Use `##` and `###` headers to organize sections
- Put commands and code in fenced code blocks with language tags (` ```bash `, ` ```python `, etc.)
- Preserve the original structure of the content
- Don't truncate — save the full content
- Add a source line at the top: `> **Source:** URL`

## Steps

1. Identify the title, source URL, author, and relevant tags
2. Determine the right vault (Studying vs Live_Style)
3. Create the folder if it doesn't exist: `mkdir -p "vault/Clippings/"`
4. Write the file with frontmatter + formatted content
5. Confirm: "Saved **[title]** to your [vault] Clippings."

If the user only gives a URL (no content), tell them to paste the content since you can't browse the web directly.
