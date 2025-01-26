# Git Secrets Template

This repository provides a template for setting up git-secrets in your projects to prevent accidental commits of sensitive information.

## Features

- Pre-configured `.gitignore` for common secret files and patterns
- `.gitallowed` file with common false-positive patterns
- Setup script for git-secrets with common patterns for:
  - API keys
  - Private keys
  - Passwords
  - Tokens
  - Service-specific patterns (AWS, Google, OpenAI, etc.)
- Pre-commit hook that checks for:
  - Secrets and sensitive data
  - Large files (>10MB)
  - Environment files

## Quick Start

1. Copy these files to your repository:
   ```bash
   cp .gitignore .gitallowed setup-git-secrets.sh /path/to/your/repo/
   ```

2. Run the setup script:
   ```bash
   cd /path/to/your/repo
   chmod +x setup-git-secrets.sh
   ./setup-git-secrets.sh
   ```

3. Test the setup:
   ```bash
   # Try to commit a file with a fake API key
   echo "api_key = 'AIzaSyC9dXrg3kQP6uZgJDwNfQ_FAKE_KEY'" > test.txt
   git add test.txt
   git commit -m "test"  # Should fail
   ```

## Customization

- Add project-specific patterns to `.gitallowed`
- Add new secret patterns:
  ```bash
  git secrets --add 'your-pattern-here'
  ```
- Modify the pre-commit hook in `.git/hooks/pre-commit`

## Maintenance

Regularly review and update:
- Allowed patterns in `.gitallowed`
- Secret patterns in git-secrets
- Pre-commit hook rules

## Contributing

Feel free to submit PRs with:
- New secret patterns
- Common false-positive patterns
- Improvements to the setup script
- Additional security checks
