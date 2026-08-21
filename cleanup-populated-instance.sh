#!/usr/bin/env bash
#
# cleanup-populated-instance.sh — delete resources created by
# populate-instance.sh, matched by --prefix. Prefix-scoped so it will not touch
# resources you did not create on a shared instance (unlike "delete the whole org").
#
# Dual-purpose: connection settings come from .gh-api-examples.conf, so
# ${GITHUB_API_BASE_URL} is already correct for GHES (/api/v3) or dotcom. On cloud,
# user suspend is a GHES-only no-op and org delete may be restricted.
#
# DESTRUCTIVE — requires an explicit typed confirmation (or --yes).
#
# Usage:
#   ./cleanup-populated-instance.sh [--prefix STR] [--hostname HOST] [--token PAT]
#                                   [--yes] [--suspend-users]
set -uo pipefail

if [ -f ./.gh-api-examples.conf ]; then
  # shellcheck disable=SC1091
  .  ./.gh-api-examples.conf
fi

PREFIX="sim"; HOSTNAME_IN=""; TOKEN="${GITHUB_TOKEN:-}"; ASSUME_YES=0; SUSPEND=0
while [ $# -gt 0 ]; do
  case "$1" in
    --prefix) PREFIX="$2"; shift 2;;
    --hostname) HOSTNAME_IN="$2"; shift 2;;
    --token) TOKEN="$2"; shift 2;;
    --yes) ASSUME_YES=1; shift;;
    --suspend-users) SUSPEND=1; shift;;
    -h|--help) echo "Usage: $0 [--prefix STR] [--hostname HOST] [--token PAT] [--yes] [--suspend-users]"; exit 0;;
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
  HOST="${API#http://}"; HOST="${HOST#https://}"; HOST="${HOST%%/*}"
else
  echo "ERROR: no hostname. Set it in .gh-api-examples.conf or pass --hostname." >&2
  exit 1
fi
CURLF="${curl_custom_flags:---no-progress-meter}"
api()  { local m="$1" p="$2"; curl $CURLF -sS -X "$m" -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" "$API$p"; }
code() { local m="$1" p="$2"; curl $CURLF -sS -o /dev/null -w '%{http_code}' -X "$m" -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github+json" "$API$p"; }

REPOS=()
while IFS= read -r line; do
  [ -n "$line" ] && REPOS+=("$line")
done < <(api GET "/search/repositories?q=${PREFIX}-repo+in:name&per_page=100" | grep -o '"full_name": *"[^"]*"' | sed 's/.*": *"\([^"]*\)"/\1/')

echo "Instance: ${API}"
echo "Matched ${#REPOS[@]} repos with prefix '${PREFIX}-repo'."
[ ${#REPOS[@]} -gt 0 ] && printf '  %s\n' "${REPOS[@]}" | head -20

if [ $ASSUME_YES -ne 1 ]; then
  echo
  read -r -p "Type the hostname '${HOST}' to confirm deletion: " ans
  [ "$ans" = "$HOST" ] || { echo "Aborted."; exit 1; }
fi

for slug in ${REPOS[@]+"${REPOS[@]}"}; do
  st=$(code DELETE "/repos/$slug")
  echo "  deleted repo $slug (HTTP $st)"
done

# delete prefixed orgs (best-effort; GHES admin API, restricted on cloud)
for i in $(seq 1 20); do
  org="${PREFIX}-org-$(printf '%02d' "$i")"
  ec=$(code GET "/orgs/$org"); [ "$ec" != "200" ] && continue
  st=$(code DELETE "/orgs/$org")
  echo "  deleted org $org (HTTP $st)"
done

if [ $SUSPEND -eq 1 ]; then
  for i in $(seq 1 100); do
    u="${PREFIX}-user-$(printf '%03d' "$i")"
    ec=$(code GET "/users/$u"); [ "$ec" != "200" ] && continue
    st=$(code PUT "/users/$u/suspended")
    echo "  suspended user $u (HTTP $st)"
  done
fi

echo "Cleanup complete."
