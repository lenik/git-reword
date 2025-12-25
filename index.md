# git-reword Package

A utility suite for rewording git commit messages in batch operations.

## Tools

- **git-reword**: Reword git commit messages from files in a directory, where each file is named after a commit and contains the new message.
- **gentestrepo**: Generate a test git repository with a specified number of random commits for testing purposes.
- **genrewords**: Generate a messagedir containing reword message files for existing commits in a repository.

## Usage Examples

- `git-reword messagedir` - Reword commits using messages from files in messagedir directory.
- `git-reword -r messagedir` - Reword commits and reset author dates to current time.
- `gentestrepo -n 10 /tmp/test-repo` - Generate a test repository with 10 commits at /tmp/test-repo.
- `gentestrepo -n 5 /tmp/repo -s 42` - Generate a test repository with 5 commits using seed 42 for reproducibility.
- `genrewords -n 5 messagedir` - Generate 5 reword message files in messagedir directory.
- `genrewords -n 3 -s 123 mydir` - Generate 3 reword message files in mydir using seed 123.

