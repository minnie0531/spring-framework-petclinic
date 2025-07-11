#!/usr/bin/env python3
"""
Commit message hook for auto-generating commit messages using AI agent.
This script will be called after commit message is created to enhance it.
"""

import sys
import os
import subprocess
from pathlib import Path


def get_staged_diff():
    """Get diff of staged changes."""
    try:
        result = subprocess.run(
            ['git', 'diff', '--cached'],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError:
        return ""


def get_staged_files():
    """Get list of staged files with their status."""
    try:
        result = subprocess.run(
            ['git', 'diff', '--cached', '--name-status'],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return ""


def read_commit_message(commit_msg_file):
    """Read the current commit message."""
    try:
        with open(commit_msg_file, 'r', encoding='utf-8') as f:
            return f.read().strip()
    except Exception as e:
        print(f"Error reading commit message: {e}")
        return ""


def generate_enhanced_message(original_msg, diff_content, file_changes):
    """
    Generate enhanced commit message using AI agent.
    
    Args:
        original_msg: Original commit message
        diff_content: Git diff content
        file_changes: File changes summary
        
    Returns:
        str: Enhanced commit message
    """
    print("Generating enhanced commit message...")
    
    # TODO: Implement AI agent commit message generation here
    # This is where you would call your AI agent to analyze changes and enhance the message
    
    if not original_msg or original_msg.startswith('#'):
        # If no message provided, generate a basic one
        enhanced_msg = "feat: Update application code\n\n"
        enhanced_msg += "# Auto-generated commit message\n"
        enhanced_msg += f"# Files changed:\n"
        
        for line in file_changes.split('\n'):
            if line.strip():
                enhanced_msg += f"# - {line.strip()}\n"
    else:
        # Enhance existing message
        enhanced_msg = original_msg
        enhanced_msg += "\n\n# Enhanced by AI agent"
    
    return enhanced_msg


def write_commit_message(commit_msg_file, message):
    """Write the enhanced commit message back to file."""
    try:
        with open(commit_msg_file, 'w', encoding='utf-8') as f:
            f.write(message)
        return True
    except Exception as e:
        print(f"Error writing commit message: {e}")
        return False


def main():
    """Main entry point for commit-msg hook."""
    if len(sys.argv) != 2:
        print("Usage: commit_msg_generator.py <commit-msg-file>")
        sys.exit(1)
    
    commit_msg_file = sys.argv[1]
    
    print("=" * 50)
    print("AI Commit Message Enhancement")
    print("=" * 50)
    
    try:
        # Read current commit message
        original_msg = read_commit_message(commit_msg_file)
        
        # Get changes information
        diff_content = get_staged_diff()
        file_changes = get_staged_files()
        
        print(f"📝 Original message: {original_msg[:50]}..." if len(original_msg) > 50 else f"📝 Original message: {original_msg}")
        
        # Generate enhanced message
        enhanced_msg = generate_enhanced_message(original_msg, diff_content, file_changes)
        
        # Write enhanced message back
        if write_commit_message(commit_msg_file, enhanced_msg):
            print("Commit message enhanced successfully!")
        else:
            print("Failed to write enhanced commit message")
            sys.exit(1)
            
    except Exception as e:
        print(f"Error during commit message enhancement: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main() 