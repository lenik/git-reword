# Makefile for git-reword project

.PHONY: all install install-debug uninstall uninstall-debug clean help

# Project directory
PROJECT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# Installation directories (respect DESTDIR and PREFIX)
DESTDIR ?=
PREFIX ?= /usr/local
INSTALL_BIN_DIR := $(DESTDIR)$(PREFIX)/bin
INSTALL_MAN_DIR := $(DESTDIR)$(PREFIX)/share/man/man1
INSTALL_BASH_COMP_DIR := $(DESTDIR)/etc/bash_completion.d

# Debug installation always uses /usr (symlinks)
DEBUG_BIN_DIR := /usr/bin
DEBUG_MAN_DIR := /usr/share/man/man1
DEBUG_BASH_COMP_DIR := /etc/bash_completion.d

# Scripts to install
SCRIPTS := git-reword gentestrepo genrewords
MAN_PAGES := man/git-reword.1 man/gentestrepo.1 man/genrewords.1
BASH_COMPLETIONS := bash-completion/git-reword bash-completion/gentestrepo bash-completion/genrewords

# Default target
all:
	@echo "Available targets:"
	@echo "  make install         - Copy files to $(PREFIX) (respects DESTDIR and PREFIX)"
	@echo "  make install-debug   - Create symlinks in /usr pointing to project scripts"
	@echo "  make uninstall       - Remove files from $(PREFIX)"
	@echo "  make uninstall-debug - Remove symlinks from /usr"
	@echo "  make clean           - Clean up temporary files"
	@echo "  make help            - Show this help message"

# Install (copy files, respects DESTDIR and PREFIX)
install:
	@echo "Installing to $(DESTDIR)$(PREFIX)..."
	@echo "Installing scripts to $(INSTALL_BIN_DIR)..."
	@mkdir -p $(INSTALL_BIN_DIR)
	@for script in $(SCRIPTS); do \
		if [ -f "$(PROJECT_DIR)/$$script" ]; then \
			echo "Installing $(INSTALL_BIN_DIR)/$$script"; \
			install -m 755 "$(PROJECT_DIR)/$$script" "$(INSTALL_BIN_DIR)/"; \
		else \
			echo "Warning: $(PROJECT_DIR)/$$script not found, skipping"; \
		fi; \
	done
	@echo "Installing man pages to $(INSTALL_MAN_DIR)..."
	@mkdir -p $(INSTALL_MAN_DIR)
	@for manpage in $(MAN_PAGES); do \
		if [ -f "$(PROJECT_DIR)/$$manpage" ]; then \
			echo "Installing $(INSTALL_MAN_DIR)/$$(basename $$manpage)"; \
			install -m 644 "$(PROJECT_DIR)/$$manpage" "$(INSTALL_MAN_DIR)/"; \
		fi; \
	done
	@echo "Installing bash completions to $(INSTALL_BASH_COMP_DIR)..."
	@mkdir -p $(INSTALL_BASH_COMP_DIR)
	@for completion in $(BASH_COMPLETIONS); do \
		if [ -f "$(PROJECT_DIR)/$$completion" ]; then \
			comp_name=$$(basename $$completion); \
			echo "Installing $(INSTALL_BASH_COMP_DIR)/$$comp_name"; \
			install -m 644 "$(PROJECT_DIR)/$$completion" "$(INSTALL_BASH_COMP_DIR)/$$comp_name"; \
		fi; \
	done
	@echo "Installation complete!"
	@echo "Files installed to $(DESTDIR)$(PREFIX)"

# Install debug symlinks (always to /usr)
install-debug:
	@echo "Installing debug symlinks to $(DEBUG_BIN_DIR)..."
	@if [ ! -d "$(DEBUG_BIN_DIR)" ]; then \
		echo "Creating directory $(DEBUG_BIN_DIR)"; \
		sudo mkdir -p $(DEBUG_BIN_DIR); \
	fi
	@for script in $(SCRIPTS); do \
		if [ -f "$(PROJECT_DIR)/$$script" ]; then \
			echo "Creating symlink $(DEBUG_BIN_DIR)/$$script -> $(PROJECT_DIR)/$$script"; \
			sudo ln -sf "$(PROJECT_DIR)/$$script" "$(DEBUG_BIN_DIR)/$$script"; \
		else \
			echo "Warning: $(PROJECT_DIR)/$$script not found, skipping"; \
		fi; \
	done
	@echo "Installing man pages to $(DEBUG_MAN_DIR)..."
	@if [ ! -d "$(DEBUG_MAN_DIR)" ]; then \
		echo "Creating directory $(DEBUG_MAN_DIR)"; \
		sudo mkdir -p $(DEBUG_MAN_DIR); \
	fi
	@for manpage in $(MAN_PAGES); do \
		if [ -f "$(PROJECT_DIR)/$$manpage" ]; then \
			echo "Installing $(DEBUG_MAN_DIR)/$$(basename $$manpage)"; \
			sudo install -m 644 "$(PROJECT_DIR)/$$manpage" "$(DEBUG_MAN_DIR)/"; \
		fi; \
	done
	@echo "Installing bash completions to $(DEBUG_BASH_COMP_DIR)..."
	@if [ ! -d "$(DEBUG_BASH_COMP_DIR)" ]; then \
		echo "Creating directory $(DEBUG_BASH_COMP_DIR)"; \
		sudo mkdir -p $(DEBUG_BASH_COMP_DIR); \
	fi
	@for completion in $(BASH_COMPLETIONS); do \
		if [ -f "$(PROJECT_DIR)/$$completion" ]; then \
			comp_name=$$(basename $$completion); \
			echo "Installing $(DEBUG_BASH_COMP_DIR)/$$comp_name"; \
			sudo install -m 644 "$(PROJECT_DIR)/$$completion" "$(DEBUG_BASH_COMP_DIR)/$$comp_name"; \
		fi; \
	done
	@echo "Installation complete!"
	@echo "You can now use the scripts from anywhere:"
	@for script in $(SCRIPTS); do \
		echo "  $$script"; \
	done
	@echo ""
	@echo "Man pages installed. Try: man git-reword"
	@echo "Bash completions installed. Restart your shell or run: source /etc/bash_completion.d/git-reword"

# Uninstall (removes copied files, respects DESTDIR and PREFIX)
uninstall:
	@echo "Uninstalling from $(DESTDIR)$(PREFIX)..."
	@echo "Removing scripts from $(INSTALL_BIN_DIR)..."
	@for script in $(SCRIPTS); do \
		script_file="$(INSTALL_BIN_DIR)/$$script"; \
		if [ -f "$$script_file" ]; then \
			echo "Removing $$script_file"; \
			rm -f "$$script_file"; \
		fi; \
	done
	@echo "Removing man pages from $(INSTALL_MAN_DIR)..."
	@for manpage in $(MAN_PAGES); do \
		man_file="$(INSTALL_MAN_DIR)/$$(basename $$manpage)"; \
		if [ -f "$$man_file" ]; then \
			echo "Removing $$man_file"; \
			rm -f "$$man_file"; \
		fi; \
	done
	@echo "Removing bash completions from $(INSTALL_BASH_COMP_DIR)..."
	@for completion in $(BASH_COMPLETIONS); do \
		comp_name=$$(basename $$completion); \
		comp_file="$(INSTALL_BASH_COMP_DIR)/$$comp_name"; \
		if [ -f "$$comp_file" ]; then \
			echo "Removing $$comp_file"; \
			rm -f "$$comp_file"; \
		fi; \
	done
	@echo "Uninstallation complete!"

# Uninstall debug symlinks (always from /usr)
uninstall-debug:
	@echo "Removing symlinks from $(DEBUG_BIN_DIR)..."
	@for script in $(SCRIPTS); do \
		if [ -L "$(DEBUG_BIN_DIR)/$$script" ]; then \
			echo "Removing $(DEBUG_BIN_DIR)/$$script"; \
			sudo rm -f "$(DEBUG_BIN_DIR)/$$script"; \
		fi; \
	done
	@echo "Removing man pages from $(DEBUG_MAN_DIR)..."
	@for manpage in $(MAN_PAGES); do \
		man_file="$(DEBUG_MAN_DIR)/$$(basename $$manpage)"; \
		if [ -f "$$man_file" ]; then \
			echo "Removing $$man_file"; \
			sudo rm -f "$$man_file"; \
		fi; \
	done
	@echo "Removing bash completions from $(DEBUG_BASH_COMP_DIR)..."
	@for completion in $(BASH_COMPLETIONS); do \
		comp_name=$$(basename $$completion); \
		comp_file="$(DEBUG_BASH_COMP_DIR)/$$comp_name"; \
		if [ -f "$$comp_file" ]; then \
			echo "Removing $$comp_file"; \
			sudo rm -f "$$comp_file"; \
		fi; \
	done
	@echo "Uninstallation complete!"

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	@rm -rf /tmp/test-repo-* /tmp/tmp.* messagedir* refs/original/
	@find . -name ".git" -type d -not -path "./.git/*" -exec rm -rf {} + 2>/dev/null || true
	@echo "Cleanup complete"

# Help target
help:
	@echo "git-reword Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make install         - Copy files to $(PREFIX) (respects DESTDIR and PREFIX)"
	@echo "  make install-debug   - Create symlinks in /usr pointing to project scripts"
	@echo "                        (always installs to /usr, requires sudo)"
	@echo "  make uninstall       - Remove files from $(PREFIX) (respects DESTDIR and PREFIX)"
	@echo "  make uninstall-debug - Remove symlinks from /usr (requires sudo)"
	@echo "  make clean           - Clean up temporary files and test artifacts"
	@echo "  make help            - Show this help message"
	@echo ""
	@echo "Install examples:"
	@echo "  make install                    # Install to $(PREFIX) (default: /usr/local)"
	@echo "  make PREFIX=/usr install         # Install to /usr"
	@echo "  make DESTDIR=/tmp/stage install  # Install to /tmp/stage/$(PREFIX) (for packaging)"
	@echo "  sudo make install-debug          # Install symlinks to /usr (for development)"
	@echo ""
	@echo "Uninstall examples:"
	@echo "  make uninstall                  # Remove from $(PREFIX)"
	@echo "  make PREFIX=/usr uninstall      # Remove from /usr"
	@echo "  sudo make uninstall-debug        # Remove symlinks from /usr"

