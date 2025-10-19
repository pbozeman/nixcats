#!/bin/sh
# Install git hooks from .githooks to .git/hooks

set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
GIT_HOOKS_DIR="$(git rev-parse --git-dir)/hooks"

if [ ! -d "$GIT_HOOKS_DIR" ]; then
  echo "Error: Not in a git repository"
  exit 1
fi

echo "Installing git hooks..."

for hook in "$SCRIPT_DIR"/*; do
  if [ -f "$hook" ]; then
    hook_name=$(basename "$hook")

    # Skip the install script and library
    if [ "$hook_name" = "install.sh" ] || [ "$hook_name" = "hook-lib.sh" ]; then
      continue
    fi

    target="$GIT_HOOKS_DIR/$hook_name"

    # Remove existing hook if it's a symlink
    if [ -L "$target" ]; then
      rm "$target"
    elif [ -f "$target" ]; then
      echo "Warning: $target already exists and is not a symlink. Skipping."
      continue
    fi

    # Create symlink
    ln -s "../../.githooks/$hook_name" "$target"
    echo "  Installed: $hook_name"
  fi
done

echo "Git hooks installed successfully!"
