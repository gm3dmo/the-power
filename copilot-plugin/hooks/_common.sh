#!/bin/bash
# Shared helper for the-power guardrail hooks.
# Sources this file at the top of each hook to get parsed input variables.
#
# Exports: TOOL_NAME, COMMAND
# Exits 0 (allow) immediately if the tool is not bash or if there is no command.
#
# IMPORTANT: Do NOT use `set -e` here. These hooks must fail-open — if anything
# goes wrong (bad input, missing jq, unexpected payload shape), we exit 0 (allow)
# rather than erroring out and blocking all tool calls.

# Trap: any unexpected error → allow (fail-open, not fail-closed)
trap 'exit 0' ERR

_INPUT=$(cat 2>/dev/null || true)

# If input is empty or not valid JSON, allow
if [ -z "$_INPUT" ] || ! echo "$_INPUT" | jq empty 2>/dev/null; then
  exit 0
fi

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

# Helper: print a red warning to stderr but allow the command to proceed
warn() {
  printf '\033[31m⚠ %s\033[0m\n' "$1" >&2
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
