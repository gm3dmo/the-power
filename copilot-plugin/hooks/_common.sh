#!/bin/bash
# Shared helper for the-power guardrail hooks.
# Sources this file at the top of each hook to get parsed input variables.
#
# Exports: TOOL_NAME, COMMAND
# Exits 0 (allow) immediately if the tool is not bash or if there is no command.

set -e

_INPUT=$(cat 2>/dev/null || true)

# Defensive: handle missing or malformed JSON gracefully
TOOL_NAME=$(echo "$_INPUT" | jq -r '.toolName // empty' 2>/dev/null || true)
if [ "$TOOL_NAME" != "bash" ]; then
  exit 0
fi

COMMAND=$(echo "$_INPUT" | jq -r '.toolArgs' 2>/dev/null | jq -r '.command // empty' 2>/dev/null || true)
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Parse cwd from payload — hooks may run from the plugin install directory,
# not from where the command will execute.
CWD=$(echo "$_INPUT" | jq -r '.cwd // empty' 2>/dev/null || true)

# Helper: emit a deny decision and exit
deny() {
  jq -n --arg reason "$1" \
    '{"permissionDecision":"deny","permissionDecisionReason":$reason}'
  exit 0
}

# Helper: find .gh-api-examples.conf by walking up from the command's
# working directory (cwd from payload), falling back to PWD.
find_config() {
  local dir="${CWD:-$PWD}"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/.gh-api-examples.conf" ]; then
      echo "$dir/.gh-api-examples.conf"
      return 0
    fi
    dir=$(dirname "$dir")
  done
  return 1
}
