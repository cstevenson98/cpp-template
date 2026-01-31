#!/bin/bash
# This script runs on the HOST before the container starts
# It ensures required files exist to prevent mount failures

set -e

echo "==================================="
echo "Pre-initialization checks..."
echo "==================================="

# Check for .gitconfig
if [ ! -f ~/.gitconfig ]; then
    echo ""
    echo "⚠️  No ~/.gitconfig found on host machine"
    echo "   Creating minimal placeholder to prevent mount failure"
    echo ""
    echo "[user]" > ~/.gitconfig
    echo "   ✓ Created ~/.gitconfig"
    echo ""
    echo "   📝 Please configure Git with your information:"
    echo "      git config --global user.name \"Your Name\""
    echo "      git config --global user.email \"your@email.com\""
    echo ""
else
    echo "✓ Found ~/.gitconfig"
    if git config --global user.name > /dev/null 2>&1; then
        echo "  User: $(git config --global user.name)"
        echo "  Email: $(git config --global user.email)"
    else
        echo "  ⚠️  Git user.name not configured"
    fi
fi

echo "==================================="
echo "Pre-initialization complete!"
echo "==================================="
