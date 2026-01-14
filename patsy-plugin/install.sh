#!/usr/bin/env bash
#
# Install Claude skills, agents, and commands by creating symlinks
# in ~/.claude/ pointing to this repository.
#
# Usage: ./install.sh [--uninstall]
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script lives (follows symlinks)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Create symlink, removing existing file/link first
create_symlink() {
    local src="$1"
    local dest="$2"

    if [[ -L "$dest" ]]; then
        rm "$dest"
    elif [[ -e "$dest" ]]; then
        warn "Backing up existing $dest to ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -sf "$src" "$dest"
    success "Linked $(basename "$src")"
}

# Remove symlinks that point to this repo
remove_symlinks() {
    local dir="$1"

    if [[ ! -d "$dir" ]]; then
        return
    fi

    for link in "$dir"/*; do
        if [[ -L "$link" ]]; then
            local target
            target="$(readlink "$link")"
            if [[ "$target" == "$SCRIPT_DIR"* ]]; then
                rm "$link"
                success "Removed $(basename "$link")"
            fi
        fi
    done
}

install() {
    info "Installing Claude skills from: $SCRIPT_DIR"
    echo ""

    # Create ~/.claude directories if they don't exist
    mkdir -p "${CLAUDE_DIR}/skills"
    mkdir -p "${CLAUDE_DIR}/agents"
    mkdir -p "${CLAUDE_DIR}/commands"

    # Install skills (each skill is a directory)
    if [[ -d "${SCRIPT_DIR}/skills" ]]; then
        info "Installing skills..."
        for skill in "${SCRIPT_DIR}/skills"/*; do
            if [[ -d "$skill" ]]; then
                create_symlink "$skill" "${CLAUDE_DIR}/skills/$(basename "$skill")"
            fi
        done
        echo ""
    fi

    # Install agents (each agent is a file)
    if [[ -d "${SCRIPT_DIR}/agents" ]]; then
        info "Installing agents..."
        for agent in "${SCRIPT_DIR}/agents"/*.md; do
            if [[ -f "$agent" ]]; then
                create_symlink "$agent" "${CLAUDE_DIR}/agents/$(basename "$agent")"
            fi
        done
        echo ""
    fi

    # Install commands (each command is a file)
    if [[ -d "${SCRIPT_DIR}/commands" ]]; then
        info "Installing commands..."
        for cmd in "${SCRIPT_DIR}/commands"/*.md; do
            if [[ -f "$cmd" ]]; then
                create_symlink "$cmd" "${CLAUDE_DIR}/commands/$(basename "$cmd")"
            fi
        done
        echo ""
    fi

    success "Installation complete!"
    echo ""
    info "Skills installed to: ${CLAUDE_DIR}/skills/"
    info "Agents installed to: ${CLAUDE_DIR}/agents/"
    info "Commands installed to: ${CLAUDE_DIR}/commands/"
    echo ""
    info "To update: cd ${SCRIPT_DIR} && git pull && ./install.sh"
}

uninstall() {
    info "Uninstalling Claude skills from: $SCRIPT_DIR"
    echo ""

    remove_symlinks "${CLAUDE_DIR}/skills"
    remove_symlinks "${CLAUDE_DIR}/agents"
    remove_symlinks "${CLAUDE_DIR}/commands"

    echo ""
    success "Uninstall complete!"
}

# Parse arguments
case "${1:-}" in
    --uninstall|-u)
        uninstall
        ;;
    --help|-h)
        echo "Usage: $0 [--uninstall]"
        echo ""
        echo "Install Claude skills by creating symlinks in ~/.claude/"
        echo ""
        echo "Options:"
        echo "  --uninstall, -u  Remove symlinks created by this script"
        echo "  --help, -h       Show this help message"
        ;;
    *)
        install
        ;;
esac
