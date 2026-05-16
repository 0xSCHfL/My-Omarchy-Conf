---
name: commit-checker
description: |-
  Check recent git commits for the AVA project and add relevant changes to context.
  Use proactively when code changes or bug fixes are discussed.

  Examples:
  - user: "What changed recently?" → list last 5 commits with file changes
  - user: "What files were modified?" → show diff for relevant commits
  - user: "Is this bug fixed yet?" → check commit messages for fixes
  - user: "Show me the latest changes" → run git log --oneline -10
---
# Commit Checker

**Action:** Run git commands in the AVA project directory:

```bash
# Recent commits (default 5)
git -C /home/sohaib/Work/projects/myP/AVA-AI-Voice-Agent-for-Asterisk log --oneline -5

# With diff summary
git -C /home/sohaib/Work/projects/myP/AVA-AI-Voice-Agent-for-Asterisk log --oneline -10 --stat

# Search commits by keyword
git -C /home/sohaib/Work/projects/myP/AVA-AI-Voice-Agent-for-Asterisk log --oneline --all --grep="keyword"
```

**Extract relevant context:**
- Commit messages for feature/bug context
- File paths modified for scope
- Add key findings to conversation context