#!/bin/bash
#
# Git Hooks Uninstallation Script
# This script removes the AI-powered git hooks from your local repository
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
HOOKS_TARGET_DIR="$REPO_ROOT/.git/hooks"

echo -e "${BLUE}===========================================${NC}"
echo -e "${BLUE}🗑️  Uninstalling AI-Powered Git Hooks${NC}"
echo -e "${BLUE}===========================================${NC}"

# Check if we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo -e "${RED}❌ Error: Not in a git repository${NC}"
    exit 1
fi

# Check if hooks directory exists
if [ ! -d "$HOOKS_TARGET_DIR" ]; then
    echo -e "${YELLOW}ℹ️  No hooks directory found. Nothing to uninstall.${NC}"
    exit 0
fi

# List hooks to be removed
echo -e "${YELLOW}🔍 Checking for installed hooks...${NC}"
hooks_to_remove=()
for hook in pre-commit commit-msg; do
    if [ -f "$HOOKS_TARGET_DIR/$hook" ]; then
        hooks_to_remove+=("$hook")
        echo -e "   📄 Found: $hook"
    fi
done

if [ ${#hooks_to_remove[@]} -eq 0 ]; then
    echo -e "${YELLOW}ℹ️  No AI-powered hooks found to remove.${NC}"
    exit 0
fi

# Confirm removal
echo ""
echo -e "${YELLOW}⚠️  This will remove the following hooks:${NC}"
for hook in "${hooks_to_remove[@]}"; do
    echo -e "   • $hook"
done
echo ""
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}ℹ️  Uninstallation cancelled.${NC}"
    exit 0
fi

# Remove hooks
echo -e "${YELLOW}🗑️  Removing hooks...${NC}"
removed_count=0
for hook in "${hooks_to_remove[@]}"; do
    if rm -f "$HOOKS_TARGET_DIR/$hook"; then
        echo -e "   ✅ Removed: $hook"
        removed_count=$((removed_count + 1))
    else
        echo -e "   ❌ Failed to remove: $hook"
    fi
done

# Check for backup directories
echo -e "${YELLOW}🔍 Checking for backups...${NC}"
backup_dirs=$(find "$REPO_ROOT" -maxdepth 1 -name ".git/hooks.backup.*" -type d 2>/dev/null || true)
if [ -n "$backup_dirs" ]; then
    echo -e "${BLUE}📦 Found backup directories:${NC}"
    echo "$backup_dirs" | while read -r backup_dir; do
        if [ -n "$backup_dir" ]; then
            echo -e "   📁 $(basename "$backup_dir")"
        fi
    done
    echo -e "${BLUE}💡 You can manually restore from these backups if needed${NC}"
fi

echo -e "${BLUE}===========================================${NC}"
if [ $removed_count -eq ${#hooks_to_remove[@]} ]; then
    echo -e "${GREEN}🎉 Git hooks uninstallation completed successfully!${NC}"
    echo -e "${GREEN}   $removed_count hooks removed${NC}"
    echo ""
    echo -e "${BLUE}📋 What was removed:${NC}"
    for hook in "${hooks_to_remove[@]}"; do
        echo -e "   • ${YELLOW}$hook hook${NC}: No longer active"
    done
    echo ""
    echo -e "${BLUE}💡 Note:${NC}"
    echo -e "   • The hook scripts in ${YELLOW}hooks/${NC} directory are still available"
    echo -e "   • Python scripts in ${YELLOW}.git-hooks/${NC} are still available"
    echo -e "   • Run ${YELLOW}./install-hooks.sh${NC} to reinstall hooks anytime"
else
    echo -e "${RED}❌ Uninstallation completed with errors${NC}"
    echo -e "${RED}   Only $removed_count out of ${#hooks_to_remove[@]} hooks were removed successfully${NC}"
    exit 1
fi
echo -e "${BLUE}===========================================${NC}" 