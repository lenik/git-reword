#!/bin/bash
# Basic test for git-reword

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Clean up function
cleanup() {
    if [ -n "$REPO_DIR" ] && [ -d "$REPO_DIR" ]; then
        rm -rf "$REPO_DIR"
    fi
    if [ -n "$MESSAGEDIR" ] && [ -d "$MESSAGEDIR" ]; then
        rm -rf "$MESSAGEDIR"
    fi
}
trap cleanup EXIT

echo "=== Test 1: Basic reword functionality ==="

# Generate test repo
echo "Generating test repository..."
REPO_DIR=$(mktemp -d)
"$PROJECT_ROOT/gentestrepo" -n 5 -s 42 "$REPO_DIR" > /dev/null 2>&1
if [ ! -d "$REPO_DIR" ] || [ ! -d "$REPO_DIR/.git" ]; then
    echo "Failed to create repository in $REPO_DIR"
    exit 1
fi

cd "$REPO_DIR"
export REPO_DIR="$REPO_DIR"

# Get commit hashes
COMMITS=($(git log --format=%H | head -3))
if [ ${#COMMITS[@]} -lt 3 ]; then
    echo "Error: Not enough commits generated"
    exit 1
fi

# Create messagedir with reword messages
MESSAGEDIR=$(mktemp -d)
cd "$REPO_DIR"
export REPO_DIR="$REPO_DIR"
"$PROJECT_ROOT/genrewords" -n 3 -s 42 "$MESSAGEDIR" > /dev/null 2>&1

# Verify messagedir was created
if [ ! -d "$MESSAGEDIR" ]; then
    echo "Error: messagedir was not created"
    exit 1
fi

# Count files in messagedir
FILE_COUNT=$(find "$MESSAGEDIR" -type f | wc -l)
if [ "$FILE_COUNT" -lt 1 ]; then
    echo "Error: No files created in messagedir"
    exit 1
fi

echo "Created messagedir with $FILE_COUNT files"

# Test git-reword
echo "Running git-reword..."
cd "$REPO_DIR"
"$PROJECT_ROOT/git-reword" "$MESSAGEDIR" || {
    echo "Error: git-reword failed"
    exit 1
}

echo "✓ Basic test passed"

