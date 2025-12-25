#!/bin/bash
# Test validation and error handling

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== Test 3: Validation and error handling ==="

# Test 1: Not in a git repository
echo "Test: Not in git repository"
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
# Create a messagedir with a file to trigger commit resolution
mkdir -p messagedir
echo "test message" > messagedir/invalid123
# The git check happens when trying to resolve commits or run filter-repo
# We check for either our error message or git's error message
if "$PROJECT_ROOT/git-reword" messagedir 2>&1 | grep -qiE "Not in a git repository|not a git repository|not in a git repository"; then
    echo "✓ Correctly detected not in git repository"
else
    echo "✗ Failed to detect not in git repository"
    echo "Actual output:"
    "$PROJECT_ROOT/git-reword" messagedir 2>&1 || true
    exit 1
fi
rm -rf "$TMP_DIR"

# Test 2: Invalid messagedir
echo "Test: Invalid messagedir"
TEST_REPO=$(mktemp -d)
cd "$TEST_REPO"
git init > /dev/null 2>&1
git config user.name "Test" > /dev/null 2>&1
git config user.email "test@test.com" > /dev/null 2>&1
echo "test" > test.txt
git add test.txt > /dev/null 2>&1
git commit -m "test" > /dev/null 2>&1

if "$PROJECT_ROOT/git-reword" /nonexistent/dir 2>&1 | grep -qi "does not exist\|Directory.*does not exist"; then
    echo "✓ Correctly detected nonexistent directory"
else
    echo "✗ Failed to detect nonexistent directory"
    exit 1
fi
rm -rf "$TEST_REPO"

# Test 3: Empty messagedir
echo "Test: Empty messagedir"
TEST_REPO=$(mktemp -d)
cd "$TEST_REPO"
git init > /dev/null 2>&1
git config user.name "Test" > /dev/null 2>&1
git config user.email "test@test.com" > /dev/null 2>&1
echo "test" > test.txt
git add test.txt > /dev/null 2>&1
git commit -m "test" > /dev/null 2>&1

EMPTY_DIR=$(mktemp -d)
if "$PROJECT_ROOT/git-reword" "$EMPTY_DIR" 2>&1 | grep -q "No valid commit files"; then
    echo "✓ Correctly detected empty messagedir"
else
    echo "✗ Failed to detect empty messagedir"
    exit 1
fi
rm -rf "$TEST_REPO" "$EMPTY_DIR"

echo "✓ Validation tests passed"

