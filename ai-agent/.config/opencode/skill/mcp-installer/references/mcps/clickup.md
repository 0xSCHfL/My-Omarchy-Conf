---
name: clickup
url: https://clickup.com/mcp
type: remote
auth: oauth
description: ClickUp project management — tasks, lists, spaces, docs, comments
tags: [clickup, project-management, tasks, oauth]
---

# ClickUp MCP

Official ClickUp server for workspace project management.

## Installation

```jsonc
{
  "mcp": {
    "clickup": {
      "type": "remote",
      "url": "https://mcp.clickup.com/mcp",
      "oauth": {}
    }
  }
}
```

## Setup

```bash
opencode mcp auth clickup
```

OAuth flow opens in browser. Grant access to your ClickUp workspace(s).

## Features

- Create, update, complete tasks
- Move tasks between lists/statuses
- Read spaces, folders, lists, tasks
- Add comments and attachments
- Read docs and whiteboards
- Search across workspace

## Links

- [Setup docs](https://clickup.com/mcp)
- [API docs](https://clickup.com/api)
