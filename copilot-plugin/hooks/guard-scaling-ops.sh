#!/bin/bash
# Guard: scaling operations
#
# Warns when bulk-creation scripts use counts over 100.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common.sh"

# Only check bulk creation scripts
if ! echo "$COMMAND" | grep -qE "(create-many-|python-create-many-)"; then
  exit 0
fi

CONFIG=$(find_config) || exit 0

SCALING_VARS=(
  "number_of_repos"
  "number_of_orgs"
  "number_of_users_to_create_on_ghes"
  "number_of_teams"
)

for var in "${SCALING_VARS[@]}"; do
  VALUE=$(grep -E "^${var}=" "$CONFIG" 2>/dev/null | head -1 | cut -d'=' -f2 | tr -d '"' | tr -d "'" | xargs)
  if [ -n "$VALUE" ] && [ "$VALUE" -gt 100 ] 2>/dev/null; then
    deny "Bulk creation with high count detected (${var}=${VALUE}). Please confirm with the user before creating this many resources."
  fi
done
