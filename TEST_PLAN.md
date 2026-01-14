# Test Plan

This document outlines tests to verify the plugin works correctly with both installation methods.

## Prerequisites

- Claude Code CLI installed
- Git repository pushed to GitHub (e.g., `YOUR_USERNAME/claude-skills`)

---

## Test 1: Plugin Structure Validation

**Objective:** Verify the plugin structure is valid.

### Steps

1. Check required files exist:
   ```bash
   ls -la .claude-plugin/
   # Expected: plugin.json and marketplace.json
   ```

2. Validate plugin.json format:
   ```bash
   cat .claude-plugin/plugin.json | jq .
   # Expected: Valid JSON with name, version, description, author
   ```

3. Validate marketplace.json format:
   ```bash
   cat .claude-plugin/marketplace.json | jq .
   # Expected: Valid JSON with name, owner, plugins array
   ```

### Expected Results
- [ ] `.claude-plugin/plugin.json` exists and is valid JSON
- [ ] `.claude-plugin/marketplace.json` exists and is valid JSON
- [ ] `skills/` directory exists with at least one skill
- [ ] `agents/` directory exists
- [ ] `commands/` directory exists

---

## Test 2: Manual Installation (Symlink Method)

**Objective:** Verify the install.sh script correctly creates symlinks.

### Steps

1. Clone the repository:
   ```bash
   git clone git@github.com:YOUR_USERNAME/claude-skills.git /tmp/claude-skills-test
   ```

2. Run the install script:
   ```bash
   /tmp/claude-skills-test/install.sh
   ```

3. Verify symlinks were created:
   ```bash
   ls -la ~/.claude/skills/
   ls -la ~/.claude/agents/
   ls -la ~/.claude/commands/
   ```

4. Verify symlinks point to correct location:
   ```bash
   readlink ~/.claude/skills/example-skill
   # Expected: /tmp/claude-skills-test/skills/example-skill
   ```

5. Test uninstall:
   ```bash
   /tmp/claude-skills-test/install.sh --uninstall
   ls -la ~/.claude/skills/
   # Expected: symlinks removed
   ```

### Expected Results
- [ ] `install.sh` runs without errors
- [ ] Symlinks created in `~/.claude/skills/`
- [ ] Symlinks created in `~/.claude/agents/`
- [ ] Symlinks point to repository directories
- [ ] `--uninstall` removes symlinks

---

## Test 3: Plugin Marketplace Installation

**Objective:** Verify plugin can be installed via Claude Code plugin system.

### Prerequisites
- Repository pushed to GitHub

### Steps

1. Start Claude Code in any project directory

2. Add the marketplace:
   ```
   /plugin marketplace add YOUR_USERNAME/claude-skills
   ```

3. List available plugins:
   ```
   /plugin list
   ```

4. Install the plugin:
   ```
   /plugin install brian-skills@brian-marketplace
   ```

   Or directly:
   ```
   /plugin install YOUR_USERNAME/claude-skills
   ```

5. Verify installation:
   ```
   /plugin list --installed
   ```

6. Test that skills are discoverable:
   - Ask Claude something that should trigger the example-skill
   - Check if the skill appears in `/` slash command autocomplete

### Expected Results
- [ ] Marketplace added successfully
- [ ] Plugin appears in available plugins list
- [ ] Plugin installs without errors
- [ ] Skills from plugin are discoverable by Claude
- [ ] Agents from plugin are available

---

## Test 4: Skill Discovery and Activation

**Objective:** Verify skills are properly discovered and can be activated.

### Steps

1. Install the plugin using either method

2. Start a new Claude Code session

3. Type `/` to see available slash commands:
   - Look for `example-skill` in the list

4. Manually invoke a skill:
   ```
   /example-skill
   ```

5. Test automatic discovery:
   - Ask a question that matches the skill's description
   - Verify Claude offers to use the skill

### Expected Results
- [ ] Skills appear in slash command autocomplete
- [ ] Skills can be manually invoked with `/skill-name`
- [ ] Skills are automatically suggested based on description keywords

---

## Test 5: Agent Delegation

**Objective:** Verify custom agents are available and can be used.

### Steps

1. Install the plugin using either method

2. Ask Claude to review some code:
   ```
   Review this code for security issues: [paste code]
   ```

3. Check if Claude delegates to the `code-reviewer` agent

### Expected Results
- [ ] Agent is recognized by Claude
- [ ] Agent can be delegated to for appropriate tasks
- [ ] Agent respects tool restrictions (Read, Grep, Glob only)

---

## Test 6: Update Workflow

**Objective:** Verify updates propagate correctly.

### Steps

1. Make a change to a skill (e.g., update description)

2. Commit and push:
   ```bash
   git add -A && git commit -m "Update skill" && git push
   ```

3. For manual installation:
   ```bash
   cd ~/.claude-skills && git pull && ./install.sh
   ```

4. For plugin installation:
   ```
   /plugin marketplace update brian-marketplace
   ```

5. Verify changes are reflected in Claude Code

### Expected Results
- [ ] Changes detected after update
- [ ] Updated skills work correctly
- [ ] No stale cached versions

---

## Test 7: Cross-Machine Installation

**Objective:** Verify a fresh installation works on a different machine.

### Steps

1. On a new machine (or clean VM/container), install Claude Code

2. Install the plugin:
   ```
   /plugin install YOUR_USERNAME/claude-skills
   ```

   Or for manual:
   ```bash
   git clone git@github.com:YOUR_USERNAME/claude-skills.git ~/.claude-skills
   ~/.claude-skills/install.sh
   ```

3. Verify all skills, agents, and commands are available

### Expected Results
- [ ] One-command installation works
- [ ] All components load correctly
- [ ] No missing dependencies or errors

---

## Troubleshooting

### Common Issues

**Plugin not found:**
- Verify repository is public or you have access
- Check the repository name matches exactly

**Skills not appearing:**
- Check SKILL.md frontmatter is valid YAML
- Verify `name` field uses only lowercase letters and hyphens
- Ensure `description` is under 1024 characters

**Symlinks not working:**
- Verify `~/.claude/` directories exist
- Check file permissions
- Run `install.sh` with verbose output

### Debug Commands

```bash
# Check Claude plugin cache
ls -la ~/.claude/plugins/

# Check skill loading
claude --debug

# Validate YAML frontmatter
head -20 skills/example-skill/SKILL.md
```
