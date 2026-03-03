#!/bin/bash

# Disable status line for JetBrains terminals
# Status line breaks the Claude TUI in JetBrains IDEs
if [[ "$TERMINAL_EMULATOR" == "JetBrains"* ]] || [[ -n "$IDEA_INITIAL_DIRECTORY" ]]; then
    exit 0
fi

# Read JSON input from Claude
input=$(cat)

# Parse values from JSON
DIR=$(echo "$input" | jq -r '.workspace.current_dir // empty')
MODEL=$(echo "$input" | jq -r '.model.display_name // empty')
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
OUTPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
CONTEXT_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

# Calculate approximate cost (rough estimates based on Claude pricing)
# Opus 4.5: $15/$75 per million tokens (input/output)
# Sonnet 3.5: $3/$15 per million tokens (input/output)
MODEL_ID=$(echo "$input" | jq -r '.model.id // empty')
if [[ "$MODEL_ID" == *"opus"* ]]; then
    INPUT_COST=$(echo "scale=4; $INPUT_TOKENS * 15 / 1000000" | bc)
    OUTPUT_COST=$(echo "scale=4; $OUTPUT_TOKENS * 75 / 1000000" | bc)
elif [[ "$MODEL_ID" == *"sonnet"* ]]; then
    INPUT_COST=$(echo "scale=4; $INPUT_TOKENS * 3 / 1000000" | bc)
    OUTPUT_COST=$(echo "scale=4; $OUTPUT_TOKENS * 15 / 1000000" | bc)
else
    INPUT_COST=0
    OUTPUT_COST=0
fi
COST=$(echo "scale=4; $INPUT_COST + $OUTPUT_COST" | bc)

# Format directory (basename only)
PROJECT=$(basename "$DIR")

# Get git branch (if in a git repo)
GIT_BRANCH=""
IS_WORKTREE=""
if [[ -n "$DIR" ]] && [[ -d "$DIR" ]]; then
    GIT_BRANCH=$(git -C "$DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
    # Detect worktree: git-dir differs from git-common-dir when in a worktree
    GIT_DIR=$(git -C "$DIR" rev-parse --git-dir 2>/dev/null)
    GIT_COMMON_DIR=$(git -C "$DIR" rev-parse --git-common-dir 2>/dev/null)
    if [[ -n "$GIT_DIR" ]] && [[ -n "$GIT_COMMON_DIR" ]] && [[ "$GIT_DIR" != "$GIT_COMMON_DIR" ]]; then
        IS_WORKTREE=1
    fi
fi

# Shorten model name (e.g., "Claude 3.5 Sonnet" -> "Sonnet 3.5", "Claude Opus 4.5" -> "Opus 4.5")
SHORT_MODEL=$(echo "$MODEL" | sed -E 's/Claude ([0-9.]+) (.*)/\2 \1/' | sed -E 's/Claude (.*) ([0-9.]+)/\1 \2/')

# Format cost
COST_FMT=$(printf "%.3f" "$COST")

# Format tokens (k for thousands)
format_tokens() {
    local tokens=$1
    if (( tokens >= 1000000 )); then
        printf "%.1fM" "$(echo "scale=1; $tokens / 1000000" | bc)"
    elif (( tokens >= 1000 )); then
        printf "%.1fk" "$(echo "scale=1; $tokens / 1000" | bc)"
    else
        printf "%d" "$tokens"
    fi
}

INPUT_FMT=$(format_tokens "$INPUT_TOKENS")
OUTPUT_FMT=$(format_tokens "$OUTPUT_TOKENS")

# Format context percentage (already calculated in JSON)
CONTEXT_PCT_FMT=$(printf "%.0f" "$CONTEXT_PCT")

# Colors (ANSI escape codes - normal weight)
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
MAGENTA='\033[0;35m'
WHITE='\033[0;37m'
GRAY='\033[38;5;240m'
LIGHT_GRAY='\033[38;5;250m'  # Lighter gray for separator words
RESET='\033[0m'

# Nerd Font Material Design Icons (filled/heavy variants)
ICON_FOLDER="󰉖"
ICON_MODEL="󰧑"
ICON_INPUT="󰁆"
ICON_OUTPUT="󰁞"
ICON_CONTEXT="󰾅"
ICON_BRANCH="󰘬"
ICON_COST="󰮯"
ICON_WORKTREE="󰜘"

# Build worktree indicator (shown after project name)
WORKTREE_SEGMENT=""
if [[ -n "$IS_WORKTREE" ]]; then
    WORKTREE_SEGMENT=" ${LIGHT_GRAY}worktree${RESET}"
fi

# Build git branch segment (with "on" separator, Starship style)
GIT_SEGMENT=""
if [[ -n "$GIT_BRANCH" ]]; then
    GIT_SEGMENT=" ${LIGHT_GRAY}on${RESET} ${CYAN}${ICON_BRANCH} ${GIT_BRANCH}${RESET}"
fi

# Build status line with Starship-style formatting
# Format: 󰉖 Workspace on 󰘬 main using 󰧑 Opus 4.6 · $0.123 spent on 󰁆 139k 󰁞 109k 󰾅 12%
echo -e "${BLUE}${ICON_FOLDER} ${PROJECT}${RESET}${WORKTREE_SEGMENT}${GIT_SEGMENT} ${LIGHT_GRAY}using${RESET} ${MAGENTA}${ICON_MODEL} ${SHORT_MODEL}${RESET} ${GRAY}·${RESET} ${WHITE}\$${COST_FMT}${RESET} ${LIGHT_GRAY}spent on${RESET} ${GREEN}${ICON_INPUT} ${INPUT_FMT} ${ICON_OUTPUT} ${OUTPUT_FMT}${RESET} ${YELLOW}${ICON_CONTEXT} ${CONTEXT_PCT_FMT}%${RESET}"
