# Claude Skills

A collection of Claude Code plugins containing custom skills, agents, and commands.

## Repository Structure

```
claude-skills/
├── patsy-plugin/         # Plugin directory
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

Each plugin directory must contain a [.claude-plugin/plugin.json](patsy-plugin/.claude-plugin/plugin.json) manifest file.

## Installation

### Plugin Marketplace (Recommended)

Install individual plugins using the Claude Code plugin system:

```bash
# Install the patsy plugin
/plugin install bcowdery/claude-skills/patsy-plugin
```

### Manual Installation (Development)

For local development or if you prefer symlinks:

```bash
# Clone the repository
git clone git@github.com:bcowdery/claude-skills.git ~/.claude-skills

# Run the install script (creates symlinks to ~/.claude/ for all plugins)
~/.claude-skills/install.sh
```

The install script will automatically discover and install all plugins in the repository that contain a [.claude-plugin/plugin.json](patsy-plugin/.claude-plugin/plugin.json) manifest.

## Updating

### Plugin System

```bash
/plugin update patsy
```

### Manual Installation

```bash
cd ~/.claude-skills
git pull
./install.sh
```

## Plugins

### Patsy

A suite of development tools to handle the tedious bits: crafting pull requests, generating project plans, and performing structural refactoring — so you can take all the credit.

See [patsy-plugin/README.md](patsy-plugin/README.md) for details.