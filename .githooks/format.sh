#!/usr/bin/env bash
# Format Lua and Nix files

set -e

# Get list of staged files
STAGED_LUA_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.lua$' || true)
STAGED_NIX_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.nix$' || true)

# Format Lua files with stylua
if [ -n "$STAGED_LUA_FILES" ]; then
  echo "Formatting Lua files with stylua..."
  for file in $STAGED_LUA_FILES; do
    stylua "$file"
  done
fi

# Format Nix files with nixfmt-rfc-style
if [ -n "$STAGED_NIX_FILES" ]; then
  echo "Formatting Nix files with nixfmt..."
  for file in $STAGED_NIX_FILES; do
    nixfmt "$file"
  done
fi
