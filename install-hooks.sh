#!/bin/bash
#
# Git Hooks Installation Script
# This script installs the AI-powered git hooks to your local repository
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$SCRIPT_DIR")"

# Paths
HOOKS_SOURCE_DIR="$REPO_ROOT/hooks"
HOOKS_TARGET_DIR="$REPO_ROOT/.git/hooks"
PYTHON_SCRIPTS_DIR="$REPO_ROOT/.git-hooks"

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}🚀 Installing AI-Powered Git Hooks${NC}"
echo -e "${BLUE}===========================================${NC}"

# Check if we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo -e "${RED}❌ Error: Not in a git repository${NC}"
    exit 1
fi

# Check if hooks source directory exists
if [ ! -d "$HOOKS_SOURCE_DIR" ]; then
    echo -e "${RED}❌ Error: Hooks source directory not found: $HOOKS_SOURCE_DIR${NC}"
    exit 1
fi

# Check if Python scripts directory exists
if [ ! -d "$PYTHON_SCRIPTS_DIR" ]; then
    echo -e "${RED}❌ Error: Python scripts directory not found: $PYTHON_SCRIPTS_DIR${NC}"
    exit 1
fi

# Create backup of existing hooks
echo -e "${YELLOW}📦 Backing up existing hooks...${NC}"
if [ -d "$HOOKS_TARGET_DIR" ]; then
    BACKUP_DIR="$HOOKS_TARGET_DIR.backup.$(date +%Y%m%d_%H%M%S)"
    if ls "$HOOKS_TARGET_DIR"/* 1> /dev/null 2>&1; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$HOOKS_TARGET_DIR"/* "$BACKUP_DIR"/ 2>/dev/null || true
        echo -e "${GREEN}✅ Existing hooks backed up to: $BACKUP_DIR${NC}"
    fi
fi

# Install hook files
echo -e "${YELLOW}📝 Installing hook files...${NC}"
mkdir -p "$HOOKS_TARGET_DIR"

for hook_file in "$HOOKS_SOURCE_DIR"/*; do
    if [ -f "$hook_file" ]; then
        hook_name=$(basename "$hook_file")
        echo -e "   📄 Installing $hook_name"
        cp "$hook_file" "$HOOKS_TARGET_DIR/"
        chmod +x "$HOOKS_TARGET_DIR/$hook_name"
    fi
done

# Make Python scripts executable
echo -e "${YELLOW}🐍 Setting up Python scripts...${NC}"
chmod +x "$PYTHON_SCRIPTS_DIR"/*.py

# Verify installation
echo -e "${YELLOW}🔍 Verifying installation...${NC}"
hooks_count=0
for hook in pre-commit commit-msg; do
    if [ -f "$HOOKS_TARGET_DIR/$hook" ] && [ -x "$HOOKS_TARGET_DIR/$hook" ]; then
        echo -e "   ✅ $hook hook installed and executable"
        hooks_count=$((hooks_count + 1))
    else
        echo -e "   ❌ $hook hook installation failed"
    fi
done

# Check Python availability
if command -v python3 >/dev/null 2>&1; then
    echo -e "   ✅ Python 3 is available"
else
    echo -e "   ⚠️  Warning: Python 3 not found in PATH"
fi

echo -e "${BLUE}===========================================${NC}"
if [ $hooks_count -eq 2 ]; then
    echo -e "${GREEN}🎉 Git hooks installation completed successfully!${NC}"
    echo -e "${GREEN}   $hooks_count hooks installed and ready to use${NC}"
    echo ""
    echo -e "${BLUE}📋 What happens now:${NC}"
    echo -e "   • ${YELLOW}Pre-commit hook${NC}: Runs quality checks before each commit"
    echo -e "   • ${YELLOW}Commit-msg hook${NC}: Enhances commit messages with AI analysis"
    echo ""
    echo -e "${BLUE}💡 Next steps:${NC}"
    echo -e "   • Make a test commit to see the hooks in action"
    echo -e "   • Customize the AI agent integration in .git-hooks/ scripts"
    echo -e "   • Run ${YELLOW}./uninstall-hooks.sh${NC} to remove hooks if needed"
else
    echo -e "${RED}❌ Installation completed with errors${NC}"
    echo -e "${RED}   Only $hooks_count out of 2 hooks were installed successfully${NC}"
    exit 1
fi
echo -e "${BLUE}===========================================${NC}" 