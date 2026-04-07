---
name: create-test-org
description: >
  Create a fully populated test organisation on a GitHub instance using
  the-power's build-all.sh script. Includes users, teams, repos, PRs,
  branch protection, and more. Requires .gh-api-examples.conf to be
  configured first.
keywords:
  - create
  - org
  - organisation
  - organization
  - test
  - build-all
  - users
  - teams
---

# Create a Test Organisation

Use `build-all.sh` to create a complete test organisation with users,
teams, and a fully populated repository in about 60 seconds.

## Prerequisites

1. `.gh-api-examples.conf` must exist (see the `configure` skill).
2. The `org` value in the config must be unique and not already exist.
3. **GHES only**: `build-all.sh` creates users via the site-admin API.
   On github.com, the org and users must already exist.

## What gets created

`build-all.sh` creates:

- An **organisation** (via GHES admin API)
- A **webhook** with a smee.io URL
- A **team** (`Justice League` by default)
- **Users** (via GHES admin API) and adds them to the org
- A private **repository** (`testrepo`) with:
  - README, workflow, CODEOWNERS, requirements.txt
  - A feature branch with commits
  - An **issue** with a `bug` label
  - A **pull request** with code owner review request
  - **Branch protection** on main
  - A **release**
  - `.gitattributes`

## How to run

```bash
cd the-power

# 1. Verify the config is pointing at the right instance
cat .gh-api-examples.conf | grep -E '^(hostname|org)='

# 2. Run build-all.sh
./build-all.sh
```

## Use a unique org name

Always use a unique, identifiable org name:

- Good: `solvaholic-test-2026-04`, `copilot-demo-issue-42`
- Bad: `test`, `myorg`, `demo`

Change it with:

```bash
python3 gh-set-value.py --key org --value my-unique-org
```

## GitHub.com (dotcom)

On dotcom, `build-all.sh` cannot create users or orgs via the admin API.
Use `build-dotcom.sh` instead, which assumes the org and users exist:

```bash
./build-dotcom.sh
```

Or run `build-testcase` if you only need a repo inside an existing org.

## Cleanup

When done, use the `cleanup-test-data` skill. The fastest path is:

```bash
# Delete the org and everything in it
curl -X DELETE \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  "${GITHUB_API_BASE_URL}/orgs/${org}"
```

On GHES, you can also suspend test users:

```bash
./suspend-a-user.sh testuser1
```

## Error handling

- **422 "name already exists"** — the org name is taken. Change `org` in
  your config and re-run.
- **404 on admin API** — you are on dotcom (not GHES), or the token lacks
  site-admin privileges.
- **401** — token is invalid or expired.

## Boundaries

- **Do not create orgs on github.com** via the admin API. It does not exist
  on dotcom.
- **Do not run build-all.sh without confirming the target instance** with
  the user. Verify `hostname` and `org` values first.
- **Do not display the GITHUB_TOKEN.** Show only the first 8 characters.
