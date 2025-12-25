# Makefile for git-reword tests

.PHONY: all test clean help

# Get the directory where this Makefile is located
TEST_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PROJECT_ROOT := $(abspath $(TEST_DIR)/..)

# Default target
all: test

# Run all tests
test: test_basic test_renew_date test_validation
	@echo ""
	@echo "========================================="
	@echo "All tests passed!"
	@echo "========================================="

# Individual test targets
test_basic:
	@echo "Running basic functionality test..."
	@cd "$(TEST_DIR)" && PROJECT_ROOT="$(PROJECT_ROOT)" bash test_basic.sh

test_renew_date:
	@echo "Running renew author date test..."
	@cd "$(TEST_DIR)" && PROJECT_ROOT="$(PROJECT_ROOT)" bash test_renew_date.sh

test_validation:
	@echo "Running validation tests..."
	@cd "$(TEST_DIR)" && PROJECT_ROOT="$(PROJECT_ROOT)" bash test_validation.sh

# Clean up test artifacts
clean:
	@echo "Cleaning up test artifacts..."
	@rm -rf /tmp/test-repo-* /tmp/tmp.* messagedir* refs/original/
	@find . -name ".git" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "Cleanup complete"

# Help target
help:
	@echo "Available targets:"
	@echo "  make test          - Run all tests"
	@echo "  make test_basic    - Run basic functionality test"
	@echo "  make test_renew_date - Run renew author date test"
	@echo "  make test_validation - Run validation tests"
	@echo "  make clean         - Clean up test artifacts"
	@echo "  make help          - Show this help message"

