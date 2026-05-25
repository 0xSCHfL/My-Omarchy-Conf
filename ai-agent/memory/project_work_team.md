---
name: Work team — who assigns and reviews
description: Known colleagues at the user's workplace, their roles in task assignment/review, and how they appear in ClickUp
type: project
---

User's workplace uses ClickUp under **Operations / Daily Operations / Daily** for task tracking. Known people:

- **Jean** — assigner. Creates ClickUp tasks for Sohaib via the "Task Orchestrator PM" automation. First seen on the *Compile Belgian postal codes by zone* task (`86c9xgg99`), assigned 2026-05-21, due 2026-05-28. Default reviewer on his own assigned tasks.
- **Majda** — co-reviewer alongside Jean. Added as a ClickUp follower on the postal-codes task when it moved to *In Review*.
- **Sohaib** — the user. ClickUp display name "Souhaib" (note spelling). Assignee on Operations/Daily tasks.

**Why this matters:**
- When the user's ClickUp task body says "notify ___ and ___" with blanks, the most likely fill is **Jean + Majda** based on the postal-codes precedent. Confirm before stating it as fact.
- When wrapping a task, the standard close-out is: upload deliverable to the ClickUp task as an attachment → add Jean + Majda as followers → move status to *In Review*. The user does this manually in ClickUp; I don't have ClickUp write access.

**How to apply:**
- When the user starts a new task from Jean, default to assuming Jean + Majda are the reviewers unless otherwise stated.
- Project README frontmatter in `Work/Projects/<Task>/`: include `assigner`, `reviewers` fields so this context stays visible inside the vault.
- Don't add this info to a CLAUDE.md or commit — it's people-context, belongs in memory only.

**Open: things we don't know yet:**
- Majda's role/seniority (manager? peer reviewer? domain owner?).
- Whether there are other reviewers for non-Operations/Daily tasks.
- Anyone else upstream of Jean (does someone assign tasks to Jean?).
