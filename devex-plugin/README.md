# Devex Plugin

A suite of development tools to handle the tedious bits: crafting pull requests, generating project plans, performing structural refactoring.

## What's Included

### Skills

- **[/ast-refactor](skills/code-refactor/SKILL.md)** - Guide structural code refactoring with analysis and planning
- **[/ast-search](skills/code-refactor/SKILL.md)** - Guide structural code searches, helps claude understand your codebase
- **[/brainstorm](skills/brainstorm/SKILL.md)** - Brainstorming skill for software architecture design, planning, refactoring and investigation
- **[/code-review](skills/code-review/SKILL.md)** - Perform comprehensive code reviews with structured feedback
- **[/write-plan](skills/write-plan/SKILL.md)** - Create detailed implementation plans using TDD for complex features
- **[/write-skill](skills/write-skill/SKILL.md)** - Scaffold and author new Claude Code skills

### Agents

- **[code-reviewer](agents/code-reviewer.md)** - Specialized agent for in-depth code analysis and review

## Installation

### Via Claude Code Plugin System

```bash
/plugin install bcowdery/claude-skills/devex-plugin
```

### Manual Installation

From the repository root:

```bash
./install.sh
```

The install script will symlink all skills and agents to `~/.claude/` for use across all projects.

## Development

### Adding New Skills

Use the `/write-skill` skill to scaffold new skills with proper structure:

```bash
/write-skill
```

This will guide you through creating a new skill with:
- Proper YAML frontmatter
- Markdown instructions following Anthropic best practices
- Reference materials and helper scripts

### Testing Changes

After modifying skills locally, reload them by re-running the install script:

```bash
cd ~/.claude-skills
./install.sh
```

## About

**Author**: Brian Cowdery (brian@thebeardeddeveloper.co)
**License**: MIT
**Repository**: https://github.com/bcowdery/claude-skills
