# Claude Skills

Personal Claude Code skills, agents, and commands distributed as a plugin.

## Structure

```
claude-skills/
├── .claude-plugin/
│   ├── plugin.json       # Plugin manifest (required)
│   └── marketplace.json  # Marketplace definition (for distribution)
├── skills/               # Custom skills
│   └── skill-name/
│       ├── SKILL.md      # Required: skill definition
│       ├── docs/         # Optional: additional documentation
│       └── scripts/      # Optional: helper scripts
├── agents/               # Custom subagents
│   └── agent-name.md
├── commands/             # Slash commands
│   └── command-name.md
└── install.sh            # Manual installation script
```

## Installation

### Plugin Marketplace (Recommended)

After pushing this repo to GitHub, install using the Claude Code plugin system:

```bash
# Add this repo as a marketplace
/plugin marketplace add bcowdery/claude-skills

# Install the plugin
/plugin install patsy@patsy-marketplace
```

Or install directly from GitHub without adding a marketplace:

```bash
/plugin install bcowdery/claude-skills
```

### Manual Installation (Development)

For local development or if you prefer symlinks:

```bash
# Clone the repository
git clone git@github.com:bcowdery/claude-skills.git ~/.claude-skills

# Run the install script (creates symlinks to ~/.claude/)
~/.claude-skills/install.sh
```

## Updating

### Plugin System

```bash
/plugin marketplace update patsy-marketplace
```

### Manual Installation

```bash
cd ~/.claude-skills
git pull
./install.sh
```

## Plugin Configuration Files

### plugin.json

The plugin manifest at `.claude-plugin/plugin.json`:

```json
{
  "name": "patsy",
  "version": "1.0.0",
  "description": "A suite of development tools to handle the tedious bits; crafting pull requests, generating project plans, and performing structural refactoring — so you can take all the credit.",
  "author": "Brian Cowdery"
}
```

### marketplace.json

The marketplace definition at `.claude-plugin/marketplace.json` allows this repo to act as both a plugin and a marketplace:

```json
{
  "name": "brian-marketplace",
  "owner": {
    "name": "Brian Cowdery"
  },
  "plugins": [
    {
      "name": "patsy",
      "source": ".",
      "description": "A eager collection of AI skills ready to do your bidding without asking questions. Your willing accomplice in code."
    }
  ]
}
```