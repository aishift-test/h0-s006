#!/usr/bin/env bash
# Saves the student's work to GitHub every 5 minutes, so nothing is lost if the codespace stops.
# Quiet and safe: never fails, never asks anything. HACKATHON_AUTOSAVE_ONCE=1 runs one round (for tests).
cd "${WORKSPACE_DIR:-$PWD}" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
if [ -z "$(git config user.name)" ];  then git config user.name  "${GITHUB_USER:-student}"; fi
if [ -z "$(git config user.email)" ]; then git config user.email "${GITHUB_USER:-student}@users.noreply.github.com"; fi
while true; do
  if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    git add -A >/dev/null 2>&1
    git commit -qm "Autosave" >/dev/null 2>&1
    if command -v timeout >/dev/null 2>&1; then timeout 60 git push -q origin HEAD >/dev/null 2>&1 || true; else git push -q origin HEAD >/dev/null 2>&1 || true; fi
  fi
  [ -n "${HACKATHON_AUTOSAVE_ONCE:-}" ] && exit 0
  sleep "${HACKATHON_AUTOSAVE_SECONDS:-300}"
done
