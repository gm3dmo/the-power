#!/usr/bin/env bash
#
# populate-instance.sh — seed a test instance with realistic, log-generating
# activity: orgs, users, teams, repos, then inflate each repo with multi-author
# commits, feature branches, a merged pull request, issues (labelled, assigned,
# commented, ~half closed), a star, topics, and a clone/fetch read cycle.
#
# Dual-purpose (GitHub Enterprise Server AND GitHub Cloud / dotcom):
#   - Connection settings come from .gh-api-examples.conf (run configure.py first),
#     so ${GITHUB_API_BASE_URL} is already correct for GHES (/api/v3) or dotcom.
#   - User + org creation use GHES-only site-admin APIs; on cloud they are skipped
#     automatically and repos are seeded into the ${org} from your config instead.
#
# This complements create-many-* (single-type bulk) and the goodies inflate
# script (write-only, single-author): this one is tuned for realistic *activity*
# and audit-log / monitoring traffic.
#
# Usage:
#   ./populate-instance.sh [options]
#
# Config (from .gh-api-examples.conf, overridable):
#   --hostname HOST     API hostname (default: from conf). Full https:// URL is fine.
#   --token PAT         personal access token (default: GITHUB_TOKEN from conf)
#   --org NAME          target org on cloud / fallback org name (default: org from conf)
#
# Scale:
#   --scale TIER        light | medium | heavy  (preset counts; default: light)
#   --orgs N            orgs to create (GHES admin API)
#   --users N           users to create (GHES admin API)
#   --repos-per-org N   repos created inside each org
#   --prefix STR        name prefix for everything created (default: sim)
#   --owner-users a,b   existing logins to use as collaborators/assignees/mentions
#   --no-users          skip user creation (cloud, or restricted instances)
#
# Safety / behaviour:
#   --dry-run           print what would be created, make no changes
#   --yes               acknowledge a GitHub Cloud target (required for dotcom hosts)
#   -h | --help         this help
#
# Everything created shares the --prefix and repos are tagged with the topic
# "sim-generated", so verify-populated-instance.sh and cleanup-populated-instance.sh
# can find it precisely.

set -uo pipefail

# ---------- load the-power config (idiomatic: every script sources this) ----------
if [ -f ./.gh-api-examples.conf ]; then
  # shellcheck disable=SC1091
  .  ./.gh-api-examples.conf
fi

# ---------- defaults ----------
HOSTNAME_IN=""; TOKEN="${GITHUB_TOKEN:-}"; ORG_IN="${org:-}"
SCALE="light"; PREFIX="sim"
ORGS=""; USERS=""; RPO=""; OWNER_USERS=""; MAKE_USERS=1
DRYRUN=0; ASSUME_YES=0
TOPIC="sim-generated"

usage() { sed -n '2,58p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

# ---------- args ----------
while [ $# -gt 0 ]; do
  case "$1" in
    --hostname) HOSTNAME_IN="$2"; shift 2;;
    --token) TOKEN="$2"; shift 2;;
    --org) ORG_IN="$2"; shift 2;;
    --scale) SCALE="$2"; shift 2;;
    --orgs) ORGS="$2"; shift 2;;
    --users) USERS="$2"; shift 2;;
    --repos-per-org) RPO="$2"; shift 2;;
    --prefix) PREFIX="$2"; shift 2;;
    --owner-users) OWNER_USERS="$2"; shift 2;;
    --no-users) MAKE_USERS=0; shift;;
    --dry-run) DRYRUN=1; shift;;
    --yes) ASSUME_YES=1; shift;;
    -h|--help) usage 0;;
    *) echo "Unknown arg: $1" >&2; usage 1;;
  esac
done

[ -z "$TOKEN" ] && { echo "ERROR: no token. Set GITHUB_TOKEN in .gh-api-examples.conf (run configure.py) or pass --token." >&2; exit 1; }

# token format sanity (mirrors the-power)
case "$TOKEN" in
  ghp_*|github_pat_*|gho_*|ghu_*|ghs_*|ghr_*) : ;;
  *) echo "ERROR: token does not look like a GitHub token (ghp_/github_pat_/gho_/...)." >&2; exit 1;;
esac

# ---------- resolve API base URL (dual-purpose: GHES vs dotcom) ----------
# Prefer the value configure.py already computed; only rebuild it if the caller
# overrode --hostname, applying the same rule configure.py uses.
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
  echo "ERROR: no hostname. Set it in .gh-api-examples.conf (run configure.py) or pass --hostname." >&2
  exit 1
fi

# ---------- scale presets ----------
case "$SCALE" in
  light)  ORGS="${ORGS:-2}"; USERS="${USERS:-5}";  RPO="${RPO:-3}";;
  medium) ORGS="${ORGS:-5}"; USERS="${USERS:-15}"; RPO="${RPO:-5}";;
  heavy)  ORGS="${ORGS:-10}";USERS="${USERS:-40}"; RPO="${RPO:-8}";;
  *) echo "ERROR: --scale must be light|medium|heavy" >&2; exit 1;;
esac

# honour the-power's curl_custom_flags (e.g. --insecure for self-signed GHES certs)
CURLF="${curl_custom_flags:---no-progress-meter}"
TOK_SHOW="${TOKEN:0:8}…"

# ---------- helpers ----------
api() { # METHOD PATH [json]
  local m="$1" p="$2" d="${3:-}"
  if [ -n "$d" ]; then
    curl $CURLF -sS -X "$m" -H "Authorization: token $TOKEN" \
      -H "Accept: application/vnd.github+json" "$API$p" -d "$d"
  else
    curl $CURLF -sS -X "$m" -H "Authorization: token $TOKEN" \
      -H "Accept: application/vnd.github+json" "$API$p"
  fi
}
code() { # METHOD PATH [json] -> http status
  local m="$1" p="$2" d="${3:-}"
  if [ -n "$d" ]; then
    curl $CURLF -sS -o /dev/null -w '%{http_code}' -X "$m" -H "Authorization: token $TOKEN" \
      -H "Accept: application/vnd.github+json" "$API$p" -d "$d"
  else
    curl $CURLF -sS -o /dev/null -w '%{http_code}' -X "$m" -H "Authorization: token $TOKEN" \
      -H "Accept: application/vnd.github+json" "$API$p"
  fi
}
log()  { echo "[$(date +%H:%M:%S)] $*"; }
jnum() { grep -o "\"$1\": *[0-9]*" | head -1 | grep -o '[0-9]*'; }
pick() { local a=("$@"); echo "${a[$((RANDOM % ${#a[@]}))]}"; }

# ---------- preflight ----------
log "Target:   ${API}"
log "Token:    ${TOK_SHOW}"
log "Scale:    ${SCALE}  -> orgs=${ORGS} users=${USERS} repos/org=${RPO} prefix=${PREFIX}"
[ $DRYRUN -eq 1 ] && log "DRY RUN — no changes will be made"

if [ $DRYRUN -eq 1 ]; then
  echo "Would create: ${ORGS} orgs, ${USERS} users, $((ORGS*RPO)) repos, plus per-repo inflate (commits/branches/merged PR/issues/star/topics/read)."
  exit 0
fi

# confirm-gate for GitHub Cloud (dotcom / data-residency) targets — the-power is
# dual-purpose, so we DO allow cloud, but require explicit acknowledgement because
# it acts on real accounts/orgs. Not a hard block.
case "$HOST" in
  api.github.com|github.com|*.ghe.com)
    if [ $ASSUME_YES -ne 1 ] && [ $DRYRUN -ne 1 ]; then
      echo "" >&2
      echo "WARNING: '${HOST}' is GitHub Cloud. This will create real repos/issues/PRs" >&2
      echo "         under the '${ORG_IN:-<org from config>}' organisation." >&2
      echo "         Re-run with --yes once you have confirmed the target with the user." >&2
      exit 2
    fi
    ;;
esac

ME=$(api GET "/user" | grep -o '"login": *"[^"]*"' | head -1 | sed 's/.*"login": *"\([^"]*\)".*/\1/')
if [ -z "$ME" ]; then
  echo "ERROR: could not authenticate against ${API}. Check hostname/token (and curl_custom_flags=\"--insecure\" for self-signed lab certs)." >&2
  exit 1
fi
log "Authenticated as: ${ME}"

# collaborators/mentions pool: provided list + created users get appended
POOL=()
if [ -n "$OWNER_USERS" ]; then IFS=',' read -r -a POOL <<< "$OWNER_USERS"; fi

# ---------- 1. users (GHES site-admin API; skipped on cloud) ----------
CREATED_USERS=0
if [ $MAKE_USERS -eq 1 ]; then
  log "Creating ${USERS} users via /admin/users ..."
  for i in $(seq 1 "$USERS"); do
    u="${PREFIX}-user-$(printf '%03d' "$i")"
    st=$(code POST "/admin/users" "{\"login\":\"$u\",\"email\":\"${u}@example.com\"}")
    if [ "$st" = "201" ] || [ "$st" = "202" ]; then
      CREATED_USERS=$((CREATED_USERS+1)); POOL+=("$u")
    elif [ "$st" = "422" ]; then
      POOL+=("$u")   # already exists — still usable
    elif [ "$st" = "403" ] || [ "$st" = "404" ]; then
      log "  user API unavailable (HTTP $st) — likely GitHub Cloud / no site-admin. Skipping user creation."
      break
    fi
  done
  log "Users created: ${CREATED_USERS} (pool size: ${#POOL[@]})"
fi
[ ${#POOL[@]} -eq 0 ] && POOL=("$ME")

# ---------- per-repo inflate ----------
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
GITOPT=""
case "$CURLF" in *--insecure*|*-k*) GITOPT="-c http.sslVerify=false";; esac

inflate_repo() { # org repo lang
  local org="$1" repo="$2" lang="$3"
  local slug="$org/$repo"
  local url="https://${TOKEN}@${HOST}/${slug}.git" d="$WORK/$repo"
  rm -rf "$d"; mkdir -p "$d"
  git $GITOPT -C "$d" init -q -b main
  cat > "$d/README.md" <<EOF
# $repo

Part of the $org test org ($lang). Generated for load/log testing.
EOF
  printf '*.log\nnode_modules/\n__pycache__/\n' > "$d/.gitignore"
  echo "MIT" > "$d/LICENSE"
  case "$lang" in
    py) mkdir -p "$d/src"; printf 'def add(a,b):\n    return a+b\n' > "$d/src/app.py";;
    go) printf 'package main\nfunc Add(a,b int)int{return a+b}\nfunc main(){}\n' > "$d/main.go";;
    js) mkdir -p "$d/src"; printf 'module.exports.add=(a,b)=>a+b;\n' > "$d/src/index.js";;
  esac
  git $GITOPT -C "$d" add -A
  git $GITOPT -C "$d" -c user.name="$ME" -c user.email="${ME}@example.com" commit -qm "Initial commit: $repo"
  git $GITOPT -C "$d" remote add origin "$url"
  git $GITOPT -C "$d" push -q origin main 2>/dev/null

  # extra commits on main, varied authors (realistic multi-actor history)
  local msgs=("docs: expand README" "chore: bump deps" "feat: add endpoint" "fix: handle edge case" "test: add cases")
  for m in "${msgs[@]}"; do
    echo "// $m $(date +%s)" >> "$d/CHANGELOG.md"
    git $GITOPT -C "$d" add -A
    git $GITOPT -C "$d" -c user.name="$(pick "${POOL[@]}")" -c user.email="dev@example.com" commit -qm "$m"
  done
  git $GITOPT -C "$d" push -q origin main 2>/dev/null

  # labels
  for lb in '{"name":"bug","color":"d73a4a"}' '{"name":"enhancement","color":"a2eeef"}'; do
    api POST "/repos/$slug/labels" "$lb" >/dev/null
  done

  # feature branches + PRs (one gets merged)
  local prnums=() b
  for b in feature-a bugfix-b feature-c; do
    git $GITOPT -C "$d" checkout -q -b "$b" main
    echo "// $b $(date +%s)" >> "$d/src_${b}.txt"
    git $GITOPT -C "$d" add -A
    git $GITOPT -C "$d" -c user.name="$(pick "${POOL[@]}")" -c user.email="dev@example.com" commit -qm "feat($b): work"
    git $GITOPT -C "$d" push -q origin "$b" 2>/dev/null
    local pr num
    pr=$(api POST "/repos/$slug/pulls" "{\"title\":\"Add $b\",\"head\":\"$b\",\"base\":\"main\",\"body\":\"Implements $b. cc @$(pick "${POOL[@]}")\"}")
    num=$(echo "$pr" | jnum number)
    if [ -n "$num" ]; then
      prnums+=("$num")
      api POST "/repos/$slug/issues/$num/comments" '{"body":"LGTM overall."}' >/dev/null
    fi
    git $GITOPT -C "$d" checkout -q main
  done
  [ -n "${prnums[0]:-}" ] && api PUT "/repos/$slug/pulls/${prnums[0]}/merge" "{\"merge_method\":\"merge\"}" >/dev/null

  # issues (labelled, assigned, commented, ~half closed)
  local titles=("Crash on empty config" "Add retry logic" "Docs: update examples" "Memory leak under load" "Improve coverage")
  for t in "${titles[@]}"; do
    local iss inum
    iss=$(api POST "/repos/$slug/issues" "{\"title\":\"$t\",\"body\":\"Steps to reproduce... cc @$(pick "${POOL[@]}")\",\"labels\":[\"$(pick bug enhancement)\"],\"assignees\":[\"$(pick "${POOL[@]}")\"]}")
    inum=$(echo "$iss" | jnum number)
    if [ -n "$inum" ]; then
      api POST "/repos/$slug/issues/$inum/comments" '{"body":"Reproduced, investigating."}' >/dev/null
      [ $((RANDOM % 2)) -eq 0 ] && api PATCH "/repos/$slug/issues/$inum" '{"state":"closed"}' >/dev/null
    fi
  done

  # metadata + read traffic (star, topics, clone/fetch)
  api PUT "/user/starred/$slug" "" >/dev/null
  api PUT "/repos/$slug/topics" "{\"names\":[\"$TOPIC\",\"$PREFIX\",\"$lang\"]}" >/dev/null
  local c="$WORK/${repo}-clone"; rm -rf "$c"
  git $GITOPT clone -q "$url" "$c" 2>/dev/null && git $GITOPT -C "$c" fetch -q --all 2>/dev/null
  rm -rf "$c" "$d"
}

# ---------- 2. orgs + teams + repos ----------
LANGS=(py go js)
CREATED_ORGS=0; CREATED_REPOS=0
for o in $(seq 1 "$ORGS"); do
  org="${PREFIX}-org-$(printf '%02d' "$o")"
  st=$(code POST "/admin/organizations" "{\"login\":\"$org\",\"admin\":\"$ME\",\"profile_name\":\"$org\"}")
  if [ "$st" != "201" ] && [ "$st" != "422" ]; then
    # admin org API unavailable (cloud): seed into the configured org instead
    if [ -n "$ORG_IN" ]; then
      org="$ORG_IN"
      log "org admin API unavailable (HTTP $st) — seeding into existing org '${org}'."
    else
      log "org ${org} create failed (HTTP $st) and no --org/config org to fall back to. Skipping."
      continue
    fi
  else
    [ "$st" = "201" ] && CREATED_ORGS=$((CREATED_ORGS+1))
    log "org ${org} (HTTP $st)"
    # a team per created org
    api POST "/orgs/$org/teams" "{\"name\":\"${PREFIX}-team\",\"privacy\":\"closed\"}" >/dev/null
    # add a few members to the org
    for u in "${POOL[@]:0:3}"; do
      [ "$u" != "$ME" ] && api PUT "/orgs/$org/memberships/$u" '{"role":"member"}' >/dev/null
    done
  fi

  # repos in this org, inflated
  for r in $(seq 1 "$RPO"); do
    repo="${PREFIX}-repo-$(printf '%02d' "$o")-$(printf '%02d' "$r")"
    lang="$(pick "${LANGS[@]}")"
    st=$(code POST "/orgs/$org/repos" "{\"name\":\"$repo\",\"private\":false,\"has_issues\":true,\"auto_init\":false}")
    if [ "$st" = "201" ]; then
      CREATED_REPOS=$((CREATED_REPOS+1))
      log "  repo ${org}/${repo} ($lang) — inflating"
      inflate_repo "$org" "$repo" "$lang"
    else
      log "  repo ${org}/${repo} create failed (HTTP $st)"
    fi
  done
done

log "DONE. orgs=${CREATED_ORGS} users=${CREATED_USERS} repos=${CREATED_REPOS}"
echo
echo "Verify with:   ./verify-populated-instance.sh --prefix $PREFIX"
echo "Clean up with: ./cleanup-populated-instance.sh --prefix $PREFIX"
