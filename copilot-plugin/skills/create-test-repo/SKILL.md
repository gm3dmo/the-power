---
name: create-test-repo
description: >
  Create a test repository using the-power's build-testcase scripts. Covers
  the full decision matrix of 30+ testcase scripts for repos with PRs, issues,
  workflows, secret scanning, rulesets, runners, and more.
keywords:
  - create
  - repo
  - repository
  - test
  - build-testcase
  - PR
  - pull request
  - issue
  - workflow
  - actions
  - secret scanning
  - ruleset
  - runner
---

# Create a Test Repository

the-power ships 30+ `build-testcase*` scripts that each create a different
kind of test environment. This skill helps pick the right one.

## Prerequisites

1. `.gh-api-examples.conf` must exist (see the `configure` skill).
2. The target `org` must already exist. If it does not, use the
   `create-test-org` skill first, or run `build-all.sh`.
3. Required tools: `jq`, `curl`, `python3`, `bash` 5.x.

## Decision matrix

### General purpose

| Goal | Script |
|------|--------|
| Repo with PR, issue, branch protection, CODEOWNERS, release | `build-testcase` |
| Full org + team + users + repo | `build-all.sh` |
| Timed smoketest with pass/fail summary | `build-smoketest` |
| Dotcom-specific full setup | `build-dotcom.sh` |

### GitHub Actions workflows

| Goal | Script |
|------|--------|
| Simple workflow with dispatch events | `build-testcase-workflow-simple` |
| Workflow with repository secrets | `build-testcase-workflow-secrets` |
| Workflow with curl trace for debugging | `build-testcase-workflow-curl-trace` |
| Workflow using a GitHub App | `build-testcase-workflow-github-app` |
| Self-hosted runner workflow | `build-testcase-workflow-simple-self-hosted` |
| Maven build workflow | `build-testcase-workflow-maven` |
| Merge queue demo | `build-testcase-workflow-merge-queue-demo` |

### Security features

| Goal | Script |
|------|--------|
| Secret scanning | `build-testcase-secret-scanning` |
| Push protection | `build-testcase-push-protection` |
| CodeQL zipslip detection | `build-testcase-codeql-zipslip` |
| Vulnerable dependencies | `build-testcase-shai-hulud` |

### Rulesets

| Goal | Script |
|------|--------|
| Ruleset with GitHub App override | `build-testcase-ruleset` |
| Ruleset with PR approval + org-owner override | `build-testcase-ruleset-pr-approval` |

### Self-hosted runners

| Goal | Script |
|------|--------|
| Repository-level runner | `build-testcase-selfhosted-runner` |
| Organisation-level runner | `build-testcase-selfhosted-runner-org` |
| Enterprise-level runner | `build-testcase-selfhosted-runner-enterprise` |

### Pull request variations

| Goal | Script |
|------|--------|
| PR with commit statuses and checks | `build-testcase-with-commit-status` |
| Automerge end-to-end | `build-testcase-automerge` |
| Force push scenario | `build-testcase-with-force-push-danger` |
| Merge methods (merge, squash, rebase) | `build-testcase-show-pr-merge-methods` |

### Other scenarios

| Goal | Script |
|------|--------|
| Permissions across teams | `build-testcase-permissions` |
| Public, internal, and private repos | `build-testcase-repo-trifecta` |
| Large binary file handling | `build-testcase-large-binary-jar` |
| Environments with workflow | `build-testcase-environment` |
| GHES Manage API v1 | `build-testcase-ghe-manage-v1` |
| OWASP WebGoat (Java) | `build-testcase-goat` |
| OWASP WebGoat (.NET) | `build-testcase-goat-dotnet` |

## How to run

```bash
cd the-power
./build-testcase          # fastest path to a repo with a PR
```

## Combining testcases

Run multiple testcases against the same config to layer features:

```bash
# Change repo name between runs
python3 gh-set-value.py --key repo --value my-security-repo
./build-testcase-secret-scanning
```

## GHES vs dotcom notes

- **GHES-only**: `build-testcase-ghe-manage-v1` (requires Manage API)
- **Dotcom-only**: `build-dotcom.sh` (Pages, Gists)
- **Runner scripts**: auto-rewrite `api.github.com` to `github.com` for
  runner config URL
- **Internal repos**: require GHES or Enterprise Cloud
- **User creation**: `build-all.sh` uses admin API (GHES only)

## Error handling

- **422 "name already exists"** — repo already exists. Change `repo` value.
- **404 on org** — org does not exist. Run `create-test-org` first.
- **401** — token invalid or expired.

## Boundaries

- **Confirm target instance** with the user before running any build script.
- **Do not display the GITHUB_TOKEN.** Show only the first 8 characters.
- **Do not run GHES-only scripts on dotcom.** Check `hostname` first.
