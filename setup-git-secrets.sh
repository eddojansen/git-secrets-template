#!/bin/bash

# Check if git-secrets is installed
if ! command -v git-secrets &> /dev/null; then
    echo "Installing git-secrets..."
    git clone https://github.com/awslabs/git-secrets.git
    cd git-secrets
    sudo make install
    cd ..
    rm -rf git-secrets
fi

# Initialize git-secrets in the repository
git secrets --install
git secrets --register-aws

# Add common patterns for API keys and secrets
git secrets --add 'private_key'
git secrets --add 'private.*key'
git secrets --add 'secret.*key'
git secrets --add '[a-zA-Z0-9_-]*token[a-zA-Z0-9_-]*'
git secrets --add '[a-zA-Z0-9_-]*password[a-zA-Z0-9_-]*'
git secrets --add '[a-zA-Z0-9_-]*secret[a-zA-Z0-9_-]*'
git secrets --add '-----BEGIN.*PRIVATE KEY-----'
git secrets --add '-----BEGIN.*RSA PRIVATE KEY-----'
git secrets --add '[A-Z0-9]{20}'  # Generic API key pattern
git secrets --add '[0-9a-f]{32}'  # MD5 hash pattern
git secrets --add '[0-9a-f]{40}'  # SHA1 hash pattern
git secrets --add '(?i)api[_-]?key'
git secrets --add '(?i)auth[_-]?token'

# Add patterns for specific service API keys
git secrets --add 'AIza[0-9A-Za-z-_]{35}'  # Google API Key
git secrets --add 'sk-[0-9a-zA-Z]{48}'     # OpenAI API Key
git secrets --add '[A-Z0-9]{20}'           # AWS Access Key
git secrets --add 'ghp_[a-zA-Z0-9]{36}'    # GitHub Personal Access Token
git secrets --add 'xox[baprs]-[0-9]{12}-[0-9]{12}-[0-9]{12}-[a-zA-Z0-9]{32}' # Slack Token

# Load allowed patterns from .gitallowed if it exists
if [ -f .gitallowed ]; then
    while IFS= read -r pattern || [ -n "$pattern" ]; do
        # Skip comments and empty lines
        [[ $pattern =~ ^[[:space:]]*# ]] && continue
        [[ -z "${pattern// }" ]] && continue
        git secrets --add --allowed "$pattern"
    done < .gitallowed
fi

# Set up pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

# Run git-secrets
git secrets --pre_commit_hook -- "$@"

# Check for large files (>10MB)
max_size=$((10 * 1024 * 1024))  # 10MB in bytes
for file in $(git diff --cached --name-only); do
    if [ -f "$file" ]; then
        size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
        if [ "$size" -gt $max_size ]; then
            echo "Error: $file is larger than 10MB. Please remove it from the commit."
            exit 1
        fi
    fi
done

# Check for environment files
if git diff --cached --name-only | grep -E '\.env$|\.env\.[^.]+$' > /dev/null; then
    echo "Warning: You're trying to commit an .env file. Make sure it doesn't contain secrets!"
    exit 1
fi
EOF

chmod +x .git/hooks/pre-commit

echo "Git secrets setup complete! The repository is now protected against committing secrets."
echo "Remember to:"
echo "1. Review .gitallowed for any additional patterns you need to whitelist"
echo "2. Add any project-specific patterns to git-secrets using: git secrets --add 'pattern'"
echo "3. Test the setup by trying to commit a file with a fake API key"
