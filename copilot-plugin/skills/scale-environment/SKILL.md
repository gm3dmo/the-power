---
name: scale-environment
description: >
  Scale up a test environment by bulk-creating repos, users, orgs, teams,
  issues, branches, PRs, and commits using the-power's create-many scripts.
  Three performance tiers: shell, Python connection reuse, and Python pooling.
keywords:
  - scale
  - bulk
  - many
  - create-many
  - performance
  - repos
  - users
  - orgs
  - teams
  - load
  - populate
---

# Scale Environment

Bulk-create GitHub resources to populate a test environment. Three performance
tiers are available depending on how fast you need to go.

## Working directory

All scaling scripts **must** be run from the root of a the-power repository
clone (the directory containing `.gh-api-examples.conf`).

Find an existing clone:

```bash
find ~ -maxdepth 5 -name "create-many-repos.sh" -path "*/the-power/*" 2>/dev/null
```

## Safety first

**Start small.** Create 10–50 resources to verify your config before scaling
to hundreds or thousands. Bulk creation is not easily reversible.

**Creating users is GHES-only.** The `create-many-users.sh` and
`python-create-many-users-*` scripts call the site admin API, which is only
available on GitHub Enterprise Server — not github.com.

## Configuration

All bulk scripts read defaults from `.gh-api-examples.conf`:

```
number_of_repos=3
number_of_orgs=3
number_of_teams=3
number_of_branches=10
number_of_users_to_create_on_ghes=3

repo_prefix="gestrepo"
org_prefix="fruitbat"
user_prefix="testusertoad"
team_prefix="testteam"
branch_prefix="testbranch"
file_prefix="testfile"
```

The Python scripts also accept CLI overrides:

```bash
python3 python-create-many-repos-connection-reuse.py --repos 1000 --prefix mtst1 --org acme
```

## Performance tiers

### Tier 1 — Shell scripts (simplest)

Plain curl-in-a-loop. Easy to read and modify. Each request opens a new
connection.

| Script | Creates |
|--------|---------|
| `create-many-repos.sh` | Repositories in an org |
| `create-many-users.sh` | Users (🔒 GHES only) |
| `create-many-teams.sh` | Teams in an org |
| `create-many-organizations.sh` | Organisations |
| `create-many-issues.sh` | Issues on a repo |
| `create-many-branches.sh` | Branches via the API |
| `create-many-branches-in-checked-out-repo.sh` | Branches via local git |
| `create-many-pull-requests.sh` | Pull requests |
| `create-many-commits-in-checked-out-repo.sh` | Commits via local git |
| `create-many-project-cards.sh` | Project cards |
| `create-many-repos-in-org-n.sh` | Repos across numbered orgs |
| `create-many-orgs-with-many-repos-and-inflate-them-with-goodies.sh` | Orgs + repos + extras |

### Tier 2 — Python with connection reuse (~2× faster)

Reuses a single `http.client.HTTPSConnection` for all requests, cutting out
TCP/TLS handshake overhead per call.

| Script | Creates |
|--------|---------|
| `python-create-many-repos-connection-reuse.py` | Repositories |
| `python-create-many-orgs-connection-reuse.py` | Organisations |
| `python-create-many-users-connection-reuse.py` | Users (🔒 GHES only) |
| `python-create-many-issues-connection-reuse.py` | Issues |
| `python-create-many-issues-w-comments-connection-reuse.py` | Issues with comments |

### Tier 3 — Python with connection pooling (~4× faster)

Uses `urllib3` connection pooling for maximum throughput. Requires:

```bash
pip install urllib3
```

| Script | Creates |
|--------|---------|
| `python-create-many-repos-connection-reuse-pool.py` | Repositories |
| `python-create-many-orgs-connection-reuse-pool.py` | Organisations |
| `python-create-many-users-connection-reuse-pool.py` | Users (🔒 GHES only) |

## Choosing a tier

| Need | Recommendation |
|------|----------------|
| A handful of resources (< 50) | Tier 1 shell scripts |
| Hundreds of resources | Tier 2 connection reuse |
| 1000+ resources | Tier 3 pooling |

## Benchmarks

Measured against a GHES test instance:

### 30 repos

| Method | Time |
|--------|------|
| `create-many-repos.sh` | ~32s |
| `python-create-many-repos-connection-reuse.py` | ~16s |

### 1000 repos

| Method | Time |
|--------|------|
| `create-many-repos.sh` | ~15 min |
| `python-create-many-repos-connection-reuse.py` | ~9 min |
| `python-create-many-repos-connection-reuse-pool.py` | ~3 min |

### 1000 orgs

| Method | Time |
|--------|------|
| `python-create-many-orgs-connection-reuse.py` | ~7 min |

## Example workflow

```bash
# 1. Configure for the target instance
cat .gh-api-examples.conf | grep -E '^(hostname|org)='

# 2. Verify with a small run
number_of_repos=5 ./create-many-repos.sh

# 3. Scale up with Python pooling
pip install urllib3
python3 python-create-many-repos-connection-reuse-pool.py \
  --repos 1000 --prefix load --org acme
```

## Error handling

- **422 "name already exists"** — a resource with that prefix already exists.
  Change the prefix or bump the starting number.
- **403 rate limit** — you are hitting secondary rate limits. Reduce batch size
  or add a delay between requests.
- **401** — token is invalid or expired.
- **404** — the target org does not exist. Create it first (see
  `create-test-org` skill).

## Boundaries

- **Do not bulk-create on github.com** without understanding the rate limits.
  Dotcom has stricter secondary rate limits than GHES.
- **Do not create users on github.com.** The admin user API is GHES-only.
- **Always confirm the target instance and count** with the user before running
  bulk scripts.
- **Do not display the GITHUB_TOKEN.** Show only the first 8 characters.
