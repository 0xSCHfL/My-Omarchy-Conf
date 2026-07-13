---
name: project-context
description: |-
  Load AVA AI Voice Agent project context and documentation. Use when working on AVA codebase
  to understand architecture, config, or troubleshooting.

  Examples:
  - user: "What is this project?" → read CLAUDE.md + AGENTS.md + directory structure
  - user: "How does the engine work?" → check CLAUDE.md core classes
  - user: "Fix a call issue" → load tools/providers structure from CLAUDE.md
  - user: "What are the build commands?" → read AGENTS.md
  - user: "How should I commit?" → read AGENTS.md commit guidelines
---
# Project Context

Reads project documentation from the workspace root:
- `CLAUDE.md` - Full project overview, architecture, tech stack
- `AGENTS.md` - Repo guidelines: build commands, coding style, testing, commit conventions, security tips
- Directory structure awareness

**Action:** Use the read tool to load both files:
1. `CLAUDE.md` located at: `/home/sohaib/Work/projects/myP/AVA-AI-Voice-Agent-for-Asterisk/CLAUDE.md`
2. `AGENTS.md` located at: `/home/sohaib/Work/projects/myP/AVA-AI-Voice-Agent-for-Asterisk/AGENTS.md`

After loading, summarize:
1. Project type and purpose
2. Key directories (`src/`, `admin_ui/`, `config/`)
3. Relevant components for the user's task
4. Build/test commands and coding conventions from AGENTS.md