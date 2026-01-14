# Patsy Plugin

A suite of development tools to handle the tedious bits: crafting pull requests, generating project plans, performing structural refactoring, and managing JIRA workflows — so you can take all the credit.

## What's Included

### Skills

- **[/code-review](skills/code-review/SKILL.md)** - Perform comprehensive code reviews with structured feedback
- **[/code-refactor](skills/code-refactor/SKILL.md)** - Guide structural code refactoring with analysis and planning
- **[/write-plan](skills/write-plan/SKILL.md)** - Create detailed implementation plans for complex features
- **[/write-skill](skills/write-skill/SKILL.md)** - Scaffold and author new Claude Code skills
- **[/jira-search](skills/jira-search/SKILL.md)** - Search and analyze JIRA issues using JQL queries
- **[/jira-create](skills/jira-create/SKILL.md)** - Create new JIRA issues with proper formatting
- **[/jira-update](skills/jira-update/SKILL.md)** - Update existing JIRA issues (status, assignee, etc.)
- **[/jira-backlog-summary](skills/jira-backlog-summary/SKILL.md)** - Generate summaries of your JIRA backlog

### Agents

- **[code-reviewer](agents/code-reviewer.md)** - Specialized agent for in-depth code analysis and review

## Installation

### Via Claude Code Plugin System

```bash
/plugin install bcowdery/claude-skills/patsy-plugin
```

### Manual Installation

From the repository root:

```bash
./install.sh
```

The install script will symlink all skills and agents to `~/.claude/` for use across all projects.

## Configuration

### JIRA Integration

The JIRA-related skills require environment variables for authentication:

```bash
export JIRA_BASE_URL="https://your-domain.atlassian.net"
export JIRA_USER_EMAIL="your-email@example.com"
export JIRA_API_TOKEN="your-api-token"
```

Add these to your shell configuration (`.zshrc`, `.bashrc`, etc.) or use a `.env` file in your project.

**Generate an API token**: https://id.atlassian.com/manage-profile/security/api-tokens

## Usage

Once installed, invoke skills using the `/` slash command prefix:

```bash
# Review code changes in the current branch
/code-review

# Create a detailed implementation plan
/write-plan Add user authentication with OAuth2

# Search JIRA for issues
/jira-search status = "In Progress" AND assignee = currentUser()

# Create a new JIRA issue
/jira-create
```

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

---

*Patsy: Your willing accomplice in code. An eager collection of AI skills ready to do your bidding without asking questions.*
