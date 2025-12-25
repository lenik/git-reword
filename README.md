# git-reword

A utility to reword git commit messages from files in a directory.

## Description

`git-reword` allows you to reword multiple git commit messages by preparing new messages in files named after the commits. This is useful for batch rewriting commit messages in a repository.

## Installation

### From Source

1. Clone or download this repository
2. Make the scripts executable:
   ```bash
   chmod +x git-reword gentestrepo genrewords
   ```
3. Optionally install to system PATH or use directly

### Debug Installation (Development)

For development, you can create symlinks to the scripts in your project directory:

```bash
sudo make install-debug
```

This creates symlinks in `/usr/bin` (default) pointing to the scripts in the project directory, installs man pages, and sets up bash completion. You can override the installation path:

```bash
sudo make PREFIX=/usr/local install-debug  # Install to /usr/local/bin
```

To remove the symlinks, man pages, and bash completions:

```bash
sudo make uninstall-debug
```

### Man Pages

After installation, man pages are available:

```bash
man git-reword
man gentestrepo
man genrewords
```

### Bash Completion

Bash completion is automatically installed to `/etc/bash_completion.d/`. After installation, restart your shell or source the completion files:

```bash
source /etc/bash_completion.d/git-reword
source /etc/bash_completion.d/gentestrepo
source /etc/bash_completion.d/genrewords
```

## Usage

### Basic Usage

1. **Prepare a messagedir**: Create a directory to hold your new commit messages
   ```bash
   mkdir messagedir
   ```

2. **Create message files**: For each commit you want to reword, create a file named after the commit (hash, short hash, or any commitish) containing the new message:
   ```bash
   echo "New commit message" > messagedir/abc1234
   echo "Another new message" > messagedir/def5678
   ```

3. **Run git-reword**:
   ```bash
   git-reword messagedir
   ```

### Options

- `-r, --reset-author-date`: Update the author date of reworded commits to the current date (by default, the original author date is preserved)

Example:
```bash
git-reword -r messagedir
```

## Helper Tools

### gentestrepo

Generate a test git repository with random commits for testing.

```bash
gentestrepo -n NUM REPO_PATH [-s SEED]
```

- `-n, --num-commits NUM`: Number of commits to generate (required)
- `-s, --seed SEED`: Random seed for reproducibility (optional)
- `REPO_PATH`: Path where the git repository will be created (required)

Example:
```bash
gentestrepo -n 10 /tmp/test-repo -s 42
```

### genrewords

Generate a messagedir with reword message files for existing commits.

```bash
genrewords -n NUM [-s SEED] [messagedir]
```

- `-n, --num-files NUM`: Number of reword message files to generate (required)
- `-s, --seed SEED`: Random seed for reproducibility (optional)
- `messagedir`: Directory to create (default: `messagedir`)

Example:
```bash
genrewords -n 5 -s 42 my-messages
```

## Requirements

- Python 3
- git
- git-filter-repo (install with `pip install git-filter-repo`)

## Testing

Run the test suite:

```bash
cd test
make test
```

Or run individual tests:
```bash
make test_basic      # Basic functionality test
make test_renew_date # Test reset author date option
make test_validation # Test validation and error handling
```

Clean up test artifacts:
```bash
make clean
```

## How It Works

`git-reword` uses `git filter-repo` to rewrite commit messages. It:

1. Reads all files in the messagedir
2. Resolves each filename to a full commit hash
3. Saves git remotes (they are removed by `git filter-repo` by default)
4. Uses `git filter-repo`'s Python API to rewrite matching commits
5. Restores git remotes after rewriting
6. Optionally updates author/committer dates if `-r` is specified

## Notes

- Original refs are automatically handled by `git filter-repo`
- The tool requires a clean working directory (no uncommitted changes)
- Commits are rewritten, so commit hashes will change
- **Git remotes are automatically preserved** - they are saved before and restored after rewriting
- Old commits are fully replaced (not mixed with new ones), so `git log` will show the same number of commits
- Use with caution on shared repositories

## License

This project is licensed under the GNU General Public License (GPL).

## Author

Lenik <git-reword@bodz.net>

Copyright (C) 2025

