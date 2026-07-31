#!/bin/bash
# Deploy landing/ to https://github.com/ghong25/ancora-landing (GitHub Pages).
# Source of truth is this folder; the repo is just the publish target.
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
git clone -q --depth 1 https://github.com/ghong25/ancora-landing.git "$TMP/site"
rsync -a --delete --exclude .git "$SRC/" "$TMP/site/"
cd "$TMP/site"
if git status --porcelain | grep -q .; then
  git add -A
  git commit -q -m "Update landing page"
  git push -q origin main
  echo "Deployed. Live in ~1 min."
else
  echo "No changes to deploy."
fi
