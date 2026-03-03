---
name: statusline-setup
description: Use when setting up, installing, or customizing the Claude Code status line. Triggers on requests to configure the status bar, show model info, token usage, cost tracking, or git branch in the terminal status area.
---

# Statusline Setup

## Overview

Install and configure a Starship-style status line for Claude Code that displays project context, git branch, model info, session cost, token usage, and context window utilization with Nerd Font icons and ANSI colors.

## Status Line Format

The installed status line renders as:

```
󰉖 ProjectName on 󰘬 branch using 󰧑 Model · $cost spent on 󰁆 input 󰁞 output 󰾅 context%
```

| Segment | Color | Description |
|---------|-------|-------------|
| Project | Blue | Current workspace directory name |
| Git Branch | Cyan | Active branch from workspace directory (shows worktree indicator when in a git worktree) |
| Model | Magenta | Shortened model name (e.g., "Opus 4.6", "Sonnet 4.6") |
| Cost | White | Approximate session cost based on model pricing |
| Tokens | Green | Input/output token counts (formatted as k/M) |
| Context | Yellow | Context window usage percentage |

Separator words ("on", "using", "spent on") render in light gray, Starship-style.

## Prerequisites

- `jq` - JSON processor (parses Claude's status JSON input)
- `bc` - Basic calculator (cost and token formatting)
- A [Nerd Font](https://www.nerdfonts.com/) installed in the terminal for icon rendering

## Installation

To install the status line:

1. Copy `scripts/statusline.sh` to `~/.claude/statusline.sh`
2. Make it executable: `chmod +x ~/.claude/statusline.sh`
3. Read `~/.claude/settings.json` to check for existing settings
4. Merge a `statusLine` entry into the existing settings JSON:

```json
{
  "statusLine": {
    "type": "command",
    "command": "<HOME>/.claude/statusline.sh"
  }
}
```

Replace `<HOME>` with the user's actual home directory path (use `$HOME` to resolve it). Do not use `~` in the command value -- Claude Code requires an absolute path.

> **📌 Important:** Read `~/.claude/settings.json` before editing. Merge the `statusLine` key into the existing JSON structure -- do not overwrite the file.

After installation, restart Claude Code for the status line to take effect.

## Uninstallation

To remove the status line:

1. Remove the `statusLine` key from `~/.claude/settings.json`
2. Delete `~/.claude/statusline.sh`

## Customization

### Model Pricing

The script calculates approximate session cost using hardcoded per-million-token pricing:

| Model | Input | Output |
|-------|-------|--------|
| Opus | $15 | $75 |
| Sonnet | $3 | $15 |

To update pricing or add new models, edit the cost calculation block in `statusline.sh`.

### Icons

Icons use Nerd Font Material Design glyphs. To swap icons, modify the icon variables near the top of the script:

```bash
ICON_FOLDER="󰉖"
ICON_MODEL="󰧑"
ICON_INPUT="󰁆"
ICON_OUTPUT="󰁞"
ICON_CONTEXT="󰾅"
ICON_BRANCH="󰘬"
ICON_COST="󰮯"
ICON_WORKTREE="󰜘"
```

### Colors

ANSI color codes control segment colors. Modify the color variables in `statusline.sh` to match a preferred terminal theme.

### JetBrains IDE

The script automatically disables itself in JetBrains terminals where the status line breaks the Claude TUI. No configuration needed.
