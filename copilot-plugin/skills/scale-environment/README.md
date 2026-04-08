# scale-environment

Bulk-create repos, users, orgs, teams, issues, branches, PRs, and commits
using the-power's `create-many-*` scripts. Three performance tiers from
simple shell loops to Python connection pooling.

## When to use

- You need to populate a GHES instance with hundreds or thousands of resources.
- You are load-testing or benchmarking an instance.
- You need a realistic-sized environment for reproducing customer issues.

## Quick start

```bash
# Small test run
number_of_repos=5 ./create-many-repos.sh

# Fast bulk creation
pip install urllib3
python3 python-create-many-repos-connection-reuse-pool.py \
  --repos 1000 --prefix load --org acme
```

## Prerequisites

- `.gh-api-examples.conf` (see `configure` skill)
- For Tier 3: `pip install urllib3`
- For user creation: GHES site-admin token

## See also

- [SKILL.md](SKILL.md) for full tier comparison and benchmarks
