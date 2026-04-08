#!/bin/bash
# Guard: token scope
#
# Warns when a classic PAT (ghp_) is used against github.com.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common.sh"

# Only check commands that look like they run a the-power script.
# Matches .sh/.py files AND extensionless build-* scripts.
if ! echo "$COMMAND" | grep -qE '(\.(sh|py)\b|/build-|^\.?/?\bbuild-)'; then
  exit 0
fi

CONFIG=$(find_config) || exit 0

# Check if targeting github.com (dotcom)
HOSTNAME=$(grep -E "^hostname=" "$CONFIG" 2>/dev/null | head -1 | cut -d'=' -f2 | tr -d '"' | tr -d "'" | xargs)
if ! echo "$HOSTNAME" | grep -q "api.github.com"; then
  exit 0
fi

# Check if using a classic PAT
TOKEN=$(grep -E "^GITHUB_TOKEN=" "$CONFIG" 2>/dev/null | head -1 | cut -d'=' -f2 | tr -d '"' | tr -d "'" | xargs)
if echo "$TOKEN" | grep -q "^ghp_"; then
  deny "You appear to be using a classic PAT (ghp_) on github.com. Consider using a fine-grained personal access token for better security. Confirm with the user before proceeding."
fi
