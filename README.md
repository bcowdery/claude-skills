# Claude Skills

A collection of Claude Code plugins containing custom skills, agents, and commands.

## Repository Structure

```
claude-skills/
├── devex-plugin/         # Plugin directory
│   ├── .claude-plugin/
│   │   └── plugin.json   # Plugin manifest (required)
│   ├── skills/           # Custom skills
│   │   └── skill-name/
│   │       ├── SKILL.md  # Required: skill definition
│   │       ├── docs/     # Optional: additional documentation
│   │       └── scripts/  # Optional: helper scripts
│   ├── agents/           # Custom subagents
│   │   └── agent-name.md
│   └── commands/         # Slash commands
│       └── command-name.md
└── install.sh            # Manual installation script
```

Each plugin directory must contain a [.claude-plugin/plugin.json](devex-plugin/.claude-plugin/plugin.json) manifest file.

## Installation

### Plugin Marketplace (Recommended)

In Claude Code, register the marketplace:
```bash
/plugin marketplace add bcowdery/claude-skills
```

Install individual plugins using the Claude Code plugin system:

```bash
/plugin install devex@bcowdery-claude-skills
```

### Manual Installation (Development)

For local development or if you prefer symlinks:

```bash
# Clone the repository
git clone git@github.com:bcowdery/claude-skills.git ~/.claude-skills

# Run the install script (creates symlinks to ~/.claude/ for all plugins)
~/.claude-skills/install.sh

# Or, run Claude Code with the --plugin-dir to load your plugins for that session
claude --plugin-dir ~/.claude-skills/devex-plugin
```

> 💡 The install script will automatically discover and install all plugins in the repository that contain a [.claude-plugin/plugin.json](devex-plugin/.claude-plugin/plugin.json) manifest.

## Updating

### Plugin System

```bash
/plugin update devex
```

### Manual Installation

```bash
cd ~/.claude-skills
git pull
./install.sh
```

## Post-Install Setup

### Status Line

Install a Starship-style status line that shows project context, git branch, model, cost, and token usage:

```bash
/devex:statusline-setup
```

## Plugins

### Devex

A suite of supercharged software development skills.

See [devex-plugin/README.md](devex-plugin/README.md) for details.