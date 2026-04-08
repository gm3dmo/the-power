#!/bin/bash
# Guard: scaling operations
#
# Warns when bulk-creation scripts use counts over 100.
# Checks config file values, inline env var overrides, and Python CLI args.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common.sh"

# Only check bulk creation scripts
if ! echo "$COMMAND" | grep -qE "(create-many-|python-create-many-)"; then
  exit 0
fi

THRESHOLD=100

# --- Check 1: Python CLI arguments (--repos N, --orgs N, --users N) ---
for flag in repos orgs users teams issues branches; do
  VALUE=$(echo "$COMMAND" | grep -oE -- "--${flag}[[:space:]]+[0-9]+" | grep -oE "[0-9]+" | head -1)
  if [ -n "$VALUE" ] && [ "$VALUE" -gt "$THRESHOLD" ] 2>/dev/null; then
    deny "Bulk creation with high count detected (--${flag} ${VALUE}). Please confirm with the user before creating this many resources."
  fi
done

# --- Check 2: Inline environment variable overrides (VAR=N ./script.sh) ---
SCALING_VARS=(
  "number_of_repos"
  "number_of_orgs"
  "number_of_users_to_create_on_ghes"
  "number_of_teams"
  "number_of_issues"
  "number_of_branches"
)

for var in "${SCALING_VARS[@]}"; do
  VALUE=$(echo "$COMMAND" | grep -oE "${var}=[0-9]+" | cut -d'=' -f2 | head -1)
  if [ -n "$VALUE" ] && [ "$VALUE" -gt "$THRESHOLD" ] 2>/dev/null; then
    deny "Bulk creation with high count detected (${var}=${VALUE}). Please confirm with the user before creating this many resources."
  fi
done

# --- Check 3: Config file values ---
CONFIG=$(find_config) || exit 0

for var in "${SCALING_VARS[@]}"; do
  VALUE=$(grep -E "^${var}=" "$CONFIG" 2>/dev/null | head -1 | cut -d'=' -f2 | tr -d '"' | tr -d "'" | xargs)
  if [ -n "$VALUE" ] && [ "$VALUE" -gt "$THRESHOLD" ] 2>/dev/null; then
    deny "Bulk creation with high count detected (${var}=${VALUE} in config). Please confirm with the user before creating this many resources."
  fi
done
