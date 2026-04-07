#!/bin/bash
# Guard: destructive operations
#
# Blocks delete, suspend, archive, remove, and transfer scripts
# from running without explicit user confirmation.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common.sh"

DESTRUCTIVE_PATTERNS=(
  "delete-"
  "suspend-a-user"
  "cancel-an-organization-invitation"
  "remove-"
  "archive-a-repo"
  "transfer-a-repo"
  "dismiss-a-review"
  "revoke-a-list-of-credentials"
)

for pattern in "${DESTRUCTIVE_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -q "$pattern"; then
    SCRIPT=$(echo "$COMMAND" | grep -oE "[a-z0-9_-]*${pattern}[a-z0-9_.-]*" | head -1)
    if [ -z "$SCRIPT" ]; then
      SCRIPT="$pattern*"
    fi
    deny "This is a destructive operation ($SCRIPT). Please confirm with the user before proceeding. Verify .gh-api-examples.conf is pointed at the intended target instance."
  fi
done
