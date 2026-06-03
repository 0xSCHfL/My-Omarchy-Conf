---
name: ava-project-workflow
description: Use when working on the AVA Asterisk AI Voice Agent project so the agent starts with the right paths, workflow, note locations, and stable architecture context.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [ava, asterisk, telephony, project-context, workflow, obsidian, clickup]
    related_skills: [local-first-project-workflow, obsidian, repo-and-server-scope-triage]
---

# AVA Project Workflow

## Overview

AVA is the user's Asterisk AI Voice Agent project. It integrates with Asterisk/ARI to run AI voice conversations, call routing, transfers, voicemail, summaries, and related telephony workflows.

This skill exists to preload the stable project context that should not need to be rediscovered every session: paths, environment split, workflow rules, note locations, and a short architecture summary.

## When to Use

Use this skill when:
- the task is about AVA code, config, deployment, logs, providers, pipelines, ARI, or Admin UI
- the user mentions AVA, vocallremote, Asterisk AI Voice Agent, or the live deployment
- you need to decide whether to inspect the local repo or the live server
- you need to place project notes in the right Obsidian location or connect work to ClickUp

Do not use this skill as a task log. Current progress, experiments, and next steps belong in the session, Obsidian Work notes, or ClickUp.

## Stable Paths

### Local repo
- `/home/sohaib/Work/projects/myP/AVA-AI-Voice-Agent-for-Asterisk`

### Live server
- SSH target: `vocallremote`
- Live repo path: `/root/AVA/AVA-AI-Voice-Agent-for-Asterisk`

### Notes and knowledge
- Obsidian Work vault: `/home/sohaib/Dropbox/Notes/Obsidian Vault/Work`
- Evergreen wiki project: `/home/sohaib/Dropbox/obsidian-wiki`

## Working Method

Default to a local-first workflow:
1. inspect and edit the local repo first
2. keep changes local until ready
3. let the user do the manual pull/restart/rebuild on the server unless they explicitly ask for live operations
4. use the live server mainly for logs, deployed-state verification, and runtime-only debugging

## User Conventions

- Keep answers short and verdict-first.
- Work incrementally, task by task.
- Use ClickUp for task/stakeholder tracking.
- Use Obsidian Work for active project execution notes.
- Use the separate obsidian-wiki setup for evergreen reusable knowledge.
- Avoid touching CRM-related databases or services; isolate new database work from the CRM stack.

## What AVA Is

AVA is an open-source AI voice agent for Asterisk/FreePBX.

High-level shape:
- Python backend engine under `src/`
- optional `local_ai_server/` for local inference
- `admin_ui/` with React frontend + FastAPI backend
- Docker/Docker Compose deployment
- telephony integration through ARI and audio transports
- provider model with both full-agent providers and modular STT→LLM→TTS pipelines

## Important Architecture Facts

- Main engine class is in `src/engine.py`.
- Audio transport can be `audiosocket` or `external_media`.
- Config follows a three-file model:
  - `config/ai-agent.yaml`
  - `config/ai-agent.local.yaml`
  - `.env`
- Provider precedence can come from dialplan variables, context provider, default provider, or active pipeline.
- Tooling includes telephony tools, business tools, HTTP tools, and MCP-backed tools.

## Scope Triage

Use the local repo by default for:
- code inspection
- edits
- diffs
- architecture reading
- preparing patches or commits

Use the live server for:
- logs
- container/runtime checks
- deployed config drift
- telephony behavior that only exists in the real environment
- Asterisk/firewall/SIP/runtime issues

## Good Default Response Pattern

1. say the verdict briefly
2. choose local repo or live server deliberately
3. keep changes narrow
4. mention exact path(s) when relevant
5. if the result affects ongoing project continuity, suggest or make the appropriate Obsidian Work update

## Pitfalls

- Do not treat the live server as the default editing environment.
- Do not store temporary weekly progress inside this skill.
- Do not assume the local repo reflects the live deployed state.
- Do not mix active project tracking with evergreen knowledge capture.

## Verification Checklist

- [ ] Working in the correct AVA path for the task
- [ ] Local-first unless runtime verification is required
- [ ] Notes routed to Obsidian Work, not mixed into evergreen wiki by default
- [ ] ClickUp used for tracking when task coordination matters
- [ ] CRM-related systems left untouched unless explicitly requested
