---
name: Work Obsidian vault location
description: Pointer to the user's Work Obsidian vault used as a knowledge base for AVA / vocallremote / ElevenLabs work
type: reference
originSessionId: 46012547-2cc6-4f5e-a7a9-bd6d32fb9f8a
---
User's Work knowledge base lives at `~/Dropbox/Notes/Obsidian Vault/Work/`. Consult it when the user asks about AVA, the outbound workflow router, vocallremote, CityMesh, ElevenLabs SIP, or any other work-project context that isn't in the current repo.

Key live notes (as of 2026-05-25):

- `Notes/servers/vocallremote/setup/ElevenLabs SIP Trunk & CityMesh Outbound.md` — end-to-end SIP flow, inbound/outbound status, the CityMesh `603 Decline` whitelist blocker (server IP `46.225.182.112`, SSH `ssh -p 7202 root@46.225.182.112`).
- `Projects/AVA Outbound Workflow Router/00 - Project Index.md` — current project goals, milestones, decision log. Status: planning. Stack: AVA + Asterisk 18 + ARI + Admin UI + Docker Compose. Test target: extension `5001`.
- `Projects/AVA Outbound Workflow Router/notes/architecture.md` — target node model (Start → Say → Branch → Context → Tool/Transfer → End), problem statement, why-outbound-first.
- `Projects/AVA Outbound Workflow Router/todo.md` — running task list.
- `Projects/AVA Outbound Workflow Router/notes/2026-05-22 - outbound-test-prep.md` — daily working notes.

Repo paths referenced by the notes:
- Local: `/home/sohaib/Work/projects/myP/AVA-AI-Voice-Agent-for-Asterisk`
- Live: `root@vocallremote:/root/AVA/AVA-AI-Voice-Agent-for-Asterisk`
- Current branch: `feat/multi-user-auth`

Caveats:
- `Projects/AI Voice Agent 'Elevenlabs'/` folder exists but is empty/older.
- Installed Obsidian plugins: `calendar`, `code-styler`, `obsidian-icon-folder`, `obsidian-style-settings` (mostly cosmetic — no LLM/RAG plugins).
- The vault syncs between the user's work and home PCs via Dropbox — any `.md` change is automatically available on both machines.

When consulting: read the specific note relevant to the question rather than scanning the whole vault. Paths contain spaces — quote them.
