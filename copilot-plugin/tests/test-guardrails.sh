#!/bin/bash
# Test suite for the-power Copilot CLI plugin guardrails.
#
# Usage: bash copilot-plugin/tests/test-guardrails.sh
#
# Each test pipes mock preToolUse JSON into a hook script and checks the
# exit code and output. Tests are table-driven for easy extension.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS_DIR="$SCRIPT_DIR/hooks"

PASS=0
FAIL=0
TOTAL=0

green() { printf "\033[32m%s\033[0m" "$1"; }
red()   { printf "\033[31m%s\033[0m" "$1"; }

# Run a single test case.
#   $1 = test name
#   $2 = hook script
#   $3 = JSON input (stdin)
#   $4 = expected result: "allow" or "deny"
#   $5 = (optional) expected substring in deny reason
run_test() {
  local name="$1" hook="$2" input="$3" expected="$4" reason_match="$5"
  TOTAL=$((TOTAL + 1))

  local output
  output=$(echo "$input" | bash "$hook" 2>/dev/null) || true

  if [ "$expected" = "deny" ]; then
    if echo "$output" | grep -q '"permissionDecision"'; then
      if [ -n "$reason_match" ] && ! echo "$output" | grep -qi "$reason_match"; then
        FAIL=$((FAIL + 1))
        printf "  $(red FAIL) %s — denied but reason missing '%s'\n" "$name" "$reason_match"
        return
      fi
      PASS=$((PASS + 1))
      printf "  $(green PASS) %s\n" "$name"
    else
      FAIL=$((FAIL + 1))
      printf "  $(red FAIL) %s — expected deny, got allow\n" "$name"
    fi
  else
    if echo "$output" | grep -q '"permissionDecision"'; then
      FAIL=$((FAIL + 1))
      printf "  $(red FAIL) %s — expected allow, got deny\n" "$name"
    else
      PASS=$((PASS + 1))
      printf "  $(green PASS) %s\n" "$name"
    fi
  fi
}

# Helper to build preToolUse JSON
make_input() {
  local tool="$1" command="$2"
  jq -n --arg t "$tool" --arg c "$command" \
    '{toolName: $t, toolArgs: {command: $c}}'
}

# -----------------------------------------------------------------------
echo "=== guard-destructive-ops ==="
# -----------------------------------------------------------------------

HOOK="$HOOKS_DIR/guard-destructive-ops.sh"

run_test "non-bash tool allowed" "$HOOK" \
  '{"toolName":"grep","toolArgs":{}}' "allow"

run_test "empty command allowed" "$HOOK" \
  '{"toolName":"bash","toolArgs":{"command":""}}' "allow"

run_test "malformed JSON allowed (no crash)" "$HOOK" \
  'not json at all' "allow"

run_test "missing toolArgs allowed" "$HOOK" \
  '{"toolName":"bash"}' "allow"

run_test "safe script allowed" "$HOOK" \
  "$(make_input bash './create-repo.sh')" "allow"

run_test "list script allowed" "$HOOK" \
  "$(make_input bash './list-organization-members.sh')" "allow"

run_test "delete-repo.sh denied" "$HOOK" \
  "$(make_input bash './delete-repo.sh my-repo')" "deny" "destructive"

run_test "delete-team.sh denied" "$HOOK" \
  "$(make_input bash './delete-team.sh alpha')" "deny" "destructive"

run_test "delete-many-teams.sh denied" "$HOOK" \
  "$(make_input bash './delete-many-teams.sh')" "deny" "destructive"

run_test "delete-environment.sh denied" "$HOOK" \
  "$(make_input bash './delete-environment.sh staging')" "deny" "destructive"

run_test "suspend-a-user.sh denied" "$HOOK" \
  "$(make_input bash './suspend-a-user.sh testuser')" "deny" "destructive"

run_test "remove-organization-membership denied" "$HOOK" \
  "$(make_input bash './remove-organization-membership-for-a-user.sh')" "deny" "destructive"

run_test "archive-a-repo.sh denied" "$HOOK" \
  "$(make_input bash './archive-a-repo.sh')" "deny" "destructive"

run_test "transfer-a-repo.sh denied" "$HOOK" \
  "$(make_input bash './transfer-a-repo.sh')" "deny" "destructive"

run_test "cancel-an-organization-invitation denied" "$HOOK" \
  "$(make_input bash './cancel-an-organization-invitation.sh')" "deny" "destructive"

run_test "dismiss-a-review denied" "$HOOK" \
  "$(make_input bash './dismiss-a-review-for-a-pull-request.sh')" "deny" "destructive"

run_test "revoke-a-list-of-credentials denied" "$HOOK" \
  "$(make_input bash './revoke-a-list-of-credentials.sh')" "deny" "destructive"

run_test "delete in pipe allowed (not a script name)" "$HOOK" \
  "$(make_input bash 'echo hello | grep delete')" "allow"

# -----------------------------------------------------------------------
echo ""
echo "=== guard-scaling-ops ==="
# -----------------------------------------------------------------------

HOOK="$HOOKS_DIR/guard-scaling-ops.sh"

run_test "non-bulk script allowed" "$HOOK" \
  "$(make_input bash './create-repo.sh')" "allow"

run_test "non-bash tool allowed" "$HOOK" \
  '{"toolName":"grep","toolArgs":{}}' "allow"

run_test "malformed JSON allowed (no crash)" "$HOOK" \
  'garbage input {}' "allow"

run_test "create-many-repos with low count allowed" "$HOOK" \
  "$(make_input bash './create-many-repos.sh')" "allow"

run_test "python-create-many-repos with low count allowed" "$HOOK" \
  "$(make_input bash 'python3 python-create-many-repos-connection-reuse.py')" "allow"

# Note: scaling tests that check config values need a .gh-api-examples.conf
# with number_of_repos>100. We test that the hook doesn't crash without one.

# -----------------------------------------------------------------------
echo ""
echo "=== guard-token-scope ==="
# -----------------------------------------------------------------------

HOOK="$HOOKS_DIR/guard-token-scope.sh"

run_test "non-bash tool allowed" "$HOOK" \
  '{"toolName":"grep","toolArgs":{}}' "allow"

run_test "non-script command allowed" "$HOOK" \
  "$(make_input bash 'ls -la')" "allow"

run_test "malformed JSON allowed (no crash)" "$HOOK" \
  '{{broken' "allow"

run_test "script command without config allowed" "$HOOK" \
  "$(make_input bash './create-repo.sh')" "allow"

# -----------------------------------------------------------------------
echo ""
echo "=== Results ==="
# -----------------------------------------------------------------------

printf "\n%d tests: $(green "%d passed"), " "$TOTAL" "$PASS"
if [ "$FAIL" -gt 0 ]; then
  printf "$(red "%d failed")\n" "$FAIL"
  exit 1
else
  printf "0 failed\n"
  exit 0
fi
