#!/bin/sh

before_hook() {
  STASH_NAME="hook-stash-$(date +%s)"
  git stash save --quiet --keep-index --include-untracked "$STASH_NAME"

  export STASH_NAME

  trap after_hook EXIT INT TERM
}

after_hook() {
  local exit_code=$?

  if git stash list | grep -q "$STASH_NAME"; then
    git stash pop --quiet
  fi

  if [ $exit_code -ne 0 ]; then
    exit $exit_code
  fi
}
