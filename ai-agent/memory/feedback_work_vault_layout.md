---
name: Work vault — put task work under Projects/, not Notes/
description: When producing deliverables for a Work ClickUp task, save them under Work/Projects/<Task Name>/ — do not use Work/Notes/
type: feedback
originSessionId: 46012547-2cc6-4f5e-a7a9-bd6d32fb9f8a
---
When producing deliverables for a Work ClickUp task (or any project-shaped work), save them under `~/Dropbox/Notes/Obsidian Vault/Work/Projects/<Task or Project Name>/` — **never under `Work/Notes/`**.

**Why:** The user corrected me after I put `belgian-postal-codes/` under `Work/Notes/`. `Notes/` is reserved for reference notes like `Notes/servers/vocallremote/...`. Each task or initiative should be its own `Projects/` subfolder, matching the existing `Projects/AVA Outbound Workflow Router/` pattern.

**How to apply:**
- New ClickUp task or work project → `Work/Projects/<Name>/`.
- Inside, mirror the existing project convention: a `README.md` (or `00 - Project Index.md`) with frontmatter (`type, created, status, tags`, plus ClickUp id / due / assigner when relevant), deliverable files at the project root, and a `source/` subfolder for raw inputs and build scripts.
- Daily notes still live at the vault root (`Work/2026-05-25.md`).
- Reference material that isn't a task (server setup, infra runbooks) belongs in `Notes/`.
