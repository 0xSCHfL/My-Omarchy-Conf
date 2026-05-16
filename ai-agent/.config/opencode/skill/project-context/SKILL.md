---
name: project-context
description: |-
  Load AVA AI Voice Agent project context and documentation. Use when working on AVA codebase
  to understand architecture, config, or troubleshooting.

  Examples:
  - user: "What is this project?" → read CLAUDE.md + directory structure
  - user: "How does the engine work?" → check CLAUDE.md core classes
  - user: "Fix a call issue" → load tools/providers structure from CLAUDE.md
---
# Project Context

Reads project documentation from the workspace root:
- `CLAUDE.md` - Full project overview, architecture, tech stack
- Directory structure awareness

**Action:** Use the read tool to load `CLAUDE.md` located at:
`/home/sohaib/Work/projects/myP/AVA-AI-Voice-Agent-for-Asterisk/CLAUDE.md`

After loading, summarize:
1. Project type and purpose
2. Key directories (`src/`, `admin_ui/`, `config/`)
3. Relevant components for the user's task