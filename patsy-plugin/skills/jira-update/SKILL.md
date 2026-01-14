---
name: jira-update
description: This skill should be used when updating existing JIRA tickets, when adding comments or work notes, when transitioning ticket status, or when the user says "update ticket", "add comment", "move to in progress", etc.
allowed-tools:
  - Bash
  - AskUserQuestion
---

# JIRA Update Skill

## Overview

Update existing JIRA tickets using the Atlassian MCP Server or Atlassian CLI (`acli`), supporting comments, field updates, and status transitions.

**Note: Prefer using the Atlassian MCP Server tools when available. The MCP server provides direct API integration without requiring CLI installation.**

## When to Use

Use this skill when:
- Adding comments or work notes to a ticket
- Updating ticket fields (assignee, priority, labels, etc.)
- Transitioning ticket status (move to In Progress, Done, etc.)
- Making multiple updates to a single ticket

Do NOT use this skill for:
- Creating new tickets (use `jira-create` instead)
- Searching for tickets (use `jira-search` instead)
- Sprint planning or backlog analysis (use `jira-backlog-summary` instead)

## Quick Reference

### MCP Server (Preferred)

**Update Issue:**
```
atlassian:updateJiraIssue
  issueKey: "KEY-123"
  fields: {
    assignee: { accountId: "user-id" },
    labels: ["label1", "label2"],
    summary: "Updated title"
  }
```

**Add Comment:**
```
atlassian:addJiraComment
  issueKey: "KEY-123"
  body: "Comment text"
```

**Transition Status:**
```
atlassian:transitionJiraIssue
  issueKey: "KEY-123"
  transitionId: "transition-id"
```

### CLI Fallback

**Add Comment:**
```bash
acli jira workitem comment create \
  --key "KEY-123" \
  --body "Comment text"
```

**Update Fields:**
```bash
acli jira workitem edit \
  --key "KEY-123" \
  --assignee "@me" \
  --labels "label1,label2"
```

**Transition Status:**
```bash
acli jira workitem transition \
  --key "KEY-123" \
  --status "In Progress"
```

## Step-by-Step Process

### 1. Check for MCP Server Availability

First, check if the Atlassian MCP Server is available by looking for these tools:
- `atlassian:updateJiraIssue` - Update issue fields
- `atlassian:addJiraComment` - Add comments to issues
- `atlassian:transitionJiraIssue` - Change issue status
- `atlassian:getJiraIssue` - Get issue details (for validation)

If MCP tools are available, prefer using them over the CLI approach.

### 2. Get Ticket Key

Extract ticket key from user input (e.g., "PROJ-123").
Validate format: `UPPERCASE-NUMBER` pattern.

### 3. Determine Update Type

Ask what to update:
- Add a comment/work note
- Update ticket fields
- Transition status
- Multiple updates at once

### 4. Gather Update Information

**For Comments:**
- Comment text (supports multi-line)

**For Field Updates:**
- Assignee (email or "@me")
- Priority (Highest, High, Medium, Low, Lowest)
- Labels (comma-separated)
- Summary (ticket title)
- Description

**For Status Transitions:**
- Target status (e.g., "In Progress", "Done", "Blocked")
- Optional comment with transition

### 5. Show Preview and Confirm

Display the operation before execution (whether using MCP or CLI).

### 6. Execute Operation

Use the appropriate MCP tool or CLI command based on availability.

### 7. Provide Summary

Show confirmation with link to ticket.

## Field Update Options

When using MCP, fields are provided as a JSON object. When using CLI, use these flags:

| Flag | Description |
|------|-------------|
| `--assignee "email"` | Assign to user |
| `--assignee "@me"` | Self-assign |
| `--remove-assignee` | Unassign ticket |
| `--labels "a,b,c"` | Set labels (comma-separated, no spaces) |
| `--remove-labels "a,b"` | Remove specific labels |
| `--summary "text"` | Update ticket title |
| `--description "text"` | Update description |
| `--description-file "path"` | Update description from file |
| `--type "Story"` | Change issue type |

## Natural Language Shortcuts

| User Says | Action |
|-----------|--------|
| "mark as done" | `--status "Done"` |
| "move to in progress" | `--status "In Progress"` |
| "assign to me" | `--assignee "@me"` |
| "unassign" | `--remove-assignee` |
| "add comment" | `comment create --body "..."` |
| "block ticket" | `--status "Blocked"` |

## Common Mistakes

| Mistake | Solution |
|---------|----------|
| Spaces in labels | Use comma-separated with no spaces: `"label1,label2"` |
| Wrong status name | Check available transitions for current status |
| Missing ticket key | Always validate KEY-123 format before making API calls |
| Forgetting confirmation | Always preview command before execution |
| Transition without comment | Offer to add a comment explaining the status change |

## Troubleshooting

- **"Issue does not exist"**: Verify ticket key is correct and accessible
- **"Field cannot be set"**: Field may not be editable or user lacks permission
- **"Transition not found"**: Status may not be available from current state
- **"Resolution is required"**: Some transitions (e.g., Done) require resolution field
- **Permission errors**: User may lack edit permission on this ticket

## Smart Features

- **Ticket Key Detection**: Extract ticket key from natural language (e.g., "update PROJ-123")
- **Batch Updates**: Support updating multiple tickets in sequence
- **Status Shortcuts**: Map common phrases to transitions:
  - "start" → In Progress
  - "done" / "complete" → Done
  - "block" → Blocked
  - "review" → In Review

## MCP Server Integration

### Available Tools

The Atlassian MCP Server provides these JIRA update tools:

- **`atlassian:updateJiraIssue`** - Update issue fields
  - Parameters: `issueKey` (string), `fields` (object with field names and values)
  - Returns: Updated issue details
  - Example fields: `summary`, `description`, `assignee`, `labels`, `priority`

- **`atlassian:addJiraComment`** - Add a comment to an issue
  - Parameters: `issueKey` (string), `body` (string - comment text)
  - Returns: Created comment details

- **`atlassian:transitionJiraIssue`** - Change issue status
  - Parameters: `issueKey` (string), `transitionId` (string or number)
  - Returns: Updated issue with new status
  - Note: Use `atlassian:getJiraIssue` first to discover available transitions

- **`atlassian:getJiraIssue`** - Get issue details
  - Parameters: `issueKey` (string)
  - Returns: Full issue details including available transitions
  - Use this to validate the issue exists and get transition IDs

### MCP vs CLI Usage

**Use MCP Server when:**
- Available in the environment
- Need structured responses
- Want consistent error handling
- Prefer direct API integration

**Use CLI when:**
- MCP server is not configured
- Need interactive prompts
- Working with custom acli configurations
- Performing complex field updates not supported by MCP

### Example MCP Workflows

**Update multiple fields:**
```
1. Use atlassian:updateJiraIssue with:
   issueKey: "KEY-123"
   fields: {
     summary: "New title",
     labels: ["bug", "high-priority"],
     assignee: { accountId: "user-id" }
   }
```

**Add comment and transition:**
```
1. Use atlassian:addJiraComment with:
   issueKey: "KEY-123"
   body: "Work completed, moving to Done"

2. Use atlassian:transitionJiraIssue with:
   issueKey: "KEY-123"
   transitionId: "31"
```
