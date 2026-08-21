#!/usr/bin/env bash
#
# verify-populated-instance.sh — tally the resources created by
# populate-instance.sh, matched by --prefix. Fills the gap where the-power can
# confirm a token/org is valid but has no post-seed "did it actually land?" count.
#
# Dual-purpose: connection settings come from .gh-api-examples.conf, so
# ${GITHUB_API_BASE_URL} is already correct for GHES (/api/v3) or dotcom.
#
# Usage:
#   ./verify-populated-instance.sh [--prefix STR] [--hostname HOST] [--token PAT]
set -uo pipefail

if [ -f ./.gh-api-examples.conf ]; then
  # shellcheck disable=SC1091
  .  ./.gh-api-examples.conf
fi

PREFIX="sim"; HOSTNAME_IN=""; TOKEN="${GITHUB_TOKEN:-}"
while [ $# -gt 0 ]; do
  case "$1" in
    --prefix) PREFIX="$2"; shift 2;;
    --hostname) HOSTNAME_IN="$2"; shift 2;;
    --token) TOKEN="$2"; shift 2;;
    -h|--help) echo "Usage: $0 [--prefix STR] [--hostname HOST] [--token PAT]"; exit 0;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done
[ -z "$TOKEN" ] && { echo "ERROR: no token. Set GITHUB_TOKEN in .gh-api-examples.conf or pass --token." >&2; exit 1; }

if [ -n "$HOSTNAME_IN" ]; then
  HOST="${HOSTNAME_IN#http://}"; HOST="${HOST#https://}"; HOST="${HOST%%/}"
  case "$HOST" in
    api.github.com) API="https://api.github.com";;
    *)              API="https://${HOST}/api/v3";;
  esac
elif [ -n "${GITHUB_API_BASE_URL:-}" ]; then
  API="${GITHUB_API_BASE_URL}"
else
  echo "ERROR: no hostname. Set it in .gh-api-examples.conf or pass --hostname." >&2
  exit 1
fi
CURLF="${curl_custom_flags:---no-progress-meter}"
api() { curl $CURLF -sS -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" "$API$1"; }

echo "Instance: ${API}   prefix: ${PREFIX}"
echo

printf "%-28s %6s %5s %5s %6s\n" REPO BRANCH PR ISSUE COMMIT
tot_pr=0; tot_iss=0; tot_br=0; n=0
for slug in $(api "/search/repositories?q=${PREFIX}-repo+in:name&per_page=100" | grep -o '"full_name": *"[^"]*"' | sed 's/.*": *"\([^"]*\)"/\1/'); do
  br=$(api "/repos/$slug/branches?per_page=100" | grep -o '"name":' | wc -l | tr -d ' ')
  pr=$(api "/repos/$slug/pulls?state=all&per_page=100" | grep -o '"number":' | wc -l | tr -d ' ')
  ai=$(api "/repos/$slug/issues?state=all&per_page=100" | grep -o '"number":' | wc -l | tr -d ' ')
  cm=$(api "/repos/$slug/commits?per_page=100" | grep -o '"sha":' | wc -l | tr -d ' '); cm=$((cm/2))
  iss=$((ai - pr))
  printf "%-28s %6s %5s %5s %6s\n" "${slug##*/}" "$br" "$pr" "$iss" "$cm"
  tot_br=$((tot_br+br)); tot_pr=$((tot_pr+pr)); tot_iss=$((tot_iss+iss)); n=$((n+1))
done
echo "-----"
echo "Repos matched: ${n}   branches=${tot_br}  PRs=${tot_pr}  issues=${tot_iss}"
