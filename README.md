# Git Secrets Template

This repository provides a template for setting up git-secrets and pre-commit hooks to prevent accidental commits of sensitive information.

## Features

- Pre-commit hook that checks for:
  - API keys and tokens
  - Passwords and secrets
  - Private keys
  - Environment variables
  - And more...
- Excludes common development directories (venv, build, etc.)
- Handles false positives via `.gitallowed`
- Smart pattern matching for various secret formats

## Setup Instructions

1. Install git-secrets:
   ```bash
   git clone https://github.com/awslabs/git-secrets.git
   cd git-secrets
   sudo make install
   ```

2. Copy the hook files:
   ```bash
   # Copy the pre-commit hook
   cp hooks/pre-commit .git/hooks/
   chmod +x .git/hooks/pre-commit
   ```

3. Copy configuration files:
   ```bash
   # Copy .gitallowed and .gitignore
   cp .gitallowed .gitignore /path/to/your/repo/
   ```

4. Initialize git-secrets in your repository:
   ```bash
   cd /path/to/your/repo
   git secrets --install
   ```

## Usage

The pre-commit hook will automatically run when you attempt to make a commit. If it detects any potential secrets:

1. The commit will be blocked
2. You'll see a message indicating which file contains the secret
3. You'll be given instructions on how to proceed

### Handling False Positives

If you encounter a false positive:

1. Open `.gitallowed`
2. Add the pattern that should be allowed
3. Commit your changes

## Excluded Directories

The following directories are excluded from secret scanning:
- `venv/`, `env/`, `ENV/` (Python virtual environments)
- `.git/` (Git directory)
- `__pycache__/` (Python cache)
- `build/`, `dist/` (Build artifacts)

## Supported Secret Patterns

The hook detects various types of secrets including:
- API keys and tokens
- Passwords in key-value pairs
- Bearer tokens
- JWT tokens
- GitHub tokens
- Stripe keys
- Google API keys
- And more...

## Contributing

Feel free to contribute additional patterns or improvements to the existing ones. Make sure to test thoroughly to avoid false positives.

## License

MIT License - Feel free to use and modify as needed.
