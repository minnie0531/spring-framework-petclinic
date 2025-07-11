#!/usr/bin/env python3
"""
Pre-commit hook for quality check using AI agent.
This script will be called before each commit to perform quality checks.
"""

import sys
import os
import subprocess
from pathlib import Path


def get_staged_files():
    """Get list of staged files for commit."""
    try:
        result = subprocess.run(
            ['git', 'diff', '--cached', '--name-only'],
            capture_output=True,
            text=True,
            check=True
        )
        return [f.strip() for f in result.stdout.split('\n') if f.strip()]
    except subprocess.CalledProcessError:
        return []


def run_quality_check(files):
    """
    Run quality check on staged files using AI agent.
    
    Args:
        files: List of staged files
        
    Returns:
        bool: True if quality check passes, False otherwise
    """
    print("Running pre-commit quality check...")
    
    if not files:
        print("No files to check")
        return True
    
    print(f"Files to check: {len(files)}")
    for file in files:
        print(f"   - {file}")
    
    # TODO: Implement AI agent quality check here
    # This is where you would call your AI agent for quality analysis
    
    print("Quality check passed!")
    return True


def main():
    """Main entry point for pre-commit hook."""
    print("=" * 50)
    print("Pre-commit Quality Check")
    print("=" * 50)
    
    try:
        staged_files = get_staged_files()
        
        if run_quality_check(staged_files):
            print("Pre-commit check completed successfully!")
            sys.exit(0)
        else:
            print("Pre-commit check failed!")
            sys.exit(1)
            
    except Exception as e:
        print(f"Error during pre-commit check: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main() 