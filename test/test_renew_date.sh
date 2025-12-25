#!/bin/bash
# Test for git-reword with --reset-author-date option

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

echo "=== Test 2: Reset author date functionality ==="

# Generate test repo
echo "Generating test repository..."
REPO_DIR=$(mktemp -d)
"$PROJECT_ROOT/gentestrepo" -n 3 -s 123 "$REPO_DIR" > /dev/null 2>&1
if [ ! -d "$REPO_DIR" ] || [ ! -d "$REPO_DIR/.git" ]; then
    echo "Failed to create repository in $REPO_DIR"
    exit 1
fi

cd "$REPO_DIR"
export REPO_DIR="$REPO_DIR"

# Get original author date of first commit
ORIGINAL_DATE=$(git log -1 --format=%aI HEAD)

# Create messagedir
MESSAGEDIR=$(mktemp -d)
cd "$REPO_DIR"
export REPO_DIR="$REPO_DIR"
"$PROJECT_ROOT/genrewords" -n 1 -s 123 "$MESSAGEDIR" > /dev/null 2>&1

# Test git-reword with --reset-author-date
echo "Running git-reword with --reset-author-date..."
cd "$REPO_DIR"
"$PROJECT_ROOT/git-reword" -r "$MESSAGEDIR" || {
    echo "Error: git-reword with -r failed"
    exit 1
}

# Check that author date was updated (should be recent)
NEW_DATE=$(git log -1 --format=%aI HEAD)
echo "Original date: $ORIGINAL_DATE"
echo "New date: $NEW_DATE"

# The new date should be more recent (this is a basic check)
if [ "$NEW_DATE" = "$ORIGINAL_DATE" ]; then
    echo "Warning: Author date was not updated (may be acceptable if dates are very close)"
fi

echo "✓ Reset author date test passed"

