---
name: discover-scripts
description: >
  Find the right the-power script by category, keyword, or goal. Covers all
  ~980 scripts organised by operation type with safety labels for destructive,
  GHES-only, and bulk operations.
keywords:
  - find
  - search
  - list
  - discover
  - scripts
  - available
  - what can
  - how to
---

# Discover Scripts

the-power contains ~980 scripts for GitHub API operations. This skill helps
you find the right one.

## Search strategy

1. **Check this skill's category tables** for the operation type.
2. **Use file name patterns** — script names match REST API operation names.
3. **Grep the repo** for keywords:
   ```bash
   ls *.sh | grep -i "webhook"
   ls *.sh | grep -i "branch-protection"
   ```
4. **Check docs/testcases.md** for orchestrated scenarios.

## Script categories

### Create resources (218 scripts)

Scripts prefixed `create-` that create a single resource via the API.

| Pattern | Examples | Notes |
|---------|----------|-------|
| `create-a-*.sh` | `create-a-deploy-key.sh`, `create-a-fork.sh` | Single REST resource |
| `create-an-*.sh` | `create-an-issue.sh`, `create-an-organization-webhook.sh` | Single REST resource |
| `create-commit-*.sh` | `create-commit-readme.sh`, `create-commit-workflow-simple.sh` | Git commits via API |
| `create-many-*.sh` | `create-many-repos.sh`, `create-many-users.sh` | ⚠️ BULK — see safety labels |
| `create-branch*.sh` | `create-branch.sh`, `create-branch-protected.sh` | Branch creation |
| `create-label*.sh` | `create-label.sh`, `create-labels.sh` | Issue labels |
| `create-team*.sh` | `create-team.sh`, `create-child-team.sh` | Teams |

### List and query resources (175 scripts)

Scripts prefixed `list-` that retrieve collections.

| Pattern | Examples |
|---------|----------|
| `list-organization-*.sh` | `list-organization-members.sh`, `list-organization-repos.sh` |
| `list-repo-*.sh` | `list-repo-collaborators.sh`, `list-repo-webhooks.sh` |
| `list-repository-*.sh` | `list-repository-issues.sh`, `list-repository-secrets.sh` |
| `list-pull-request*.sh` | `list-pull-requests.sh`, `list-pull-request-files.sh` |
| `list-team-*.sh` | `list-team-members.sh`, `list-team-repositories.sh` |
| `list-self-hosted-*.sh` | `list-self-hosted-runners-for-an-organization.sh` |

### Get single resource (134 scripts)

Scripts prefixed `get-` for retrieving a single resource.

| Pattern | Examples |
|---------|----------|
| `get-a-*.sh` | `get-a-repo.sh`, `get-a-pull-request.sh`, `get-a-check-run.sh` |
| `get-an-*.sh` | `get-an-organization.sh`, `get-an-issue.sh` |
| `get-the-*.sh` | `get-the-audit-log-for-an-enterprise.sh` |

### GraphQL queries (86 scripts)

Scripts prefixed `graphql-` for GraphQL API operations.

| Pattern | Examples |
|---------|----------|
| `graphql-list-*.sh` | `graphql-list-organization-repositories.sh` |
| `graphql-create-*.sh` | `graphql-create-issue.sh` |
| `graphql-get-*.sh` | `graphql-get-repo-size.sh` |

### Delete resources (35 scripts) ⚠️ DESTRUCTIVE

Scripts prefixed `delete-` that permanently remove resources.

| Pattern | Examples | Safety |
|---------|----------|--------|
| `delete-repo.sh` | Delete a repository | ⚠️ Irreversible |
| `delete-team.sh` | Delete a team | ⚠️ Irreversible |
| `delete-many-teams.sh` | Delete all nato-alphabet teams | ⚠️ BULK + destructive |
| `delete-branch-protection.sh` | Remove branch protection | ⚠️ Irreversible |
| `delete-environment.sh` | Delete a deployment environment | ⚠️ Irreversible |

### Update resources (21 scripts)

Scripts prefixed `update-` that modify existing resources.

| Pattern | Examples |
|---------|----------|
| `update-a-repo.sh` | Update repository settings |
| `update-a-pull-request-branch.sh` | Update PR branch |
| `update-branch-protection-with-required-check.sh` | Add required checks |

### Add/relationship (24 scripts)

Scripts prefixed `add-` that create relationships between resources.

| Pattern | Examples |
|---------|----------|
| `add-team-to-repo.sh` | Add team to a repository |
| `add-user-to-team.sh` | Add user to a team |
| `add-many-users-to-org.sh` | Bulk add users to org |
| `add-collaborator-to-repo.sh` | Add repo collaborator |

### Build/orchestration (32+ scripts) 🔨

Scripts prefixed `build-` that orchestrate multiple API calls.

See the `create-test-repo` skill for the full decision matrix.

### Bulk creation (Python, 9 scripts) ⚠️ BULK

Python scripts for high-throughput resource creation.

| Script | Speed | Notes |
|--------|-------|-------|
| `python-create-many-repos-connection-reuse.py` | ~2× bash | Connection reuse |
| `python-create-many-repos-connection-reuse-pool.py` | ~4× bash | urllib3 pooling |
| `python-create-many-users-connection-reuse.py` | ~2× bash | 🔒 GHES only |
| `python-create-many-orgs-connection-reuse.py` | ~2× bash | 🔒 GHES only |

### GHES admin (20+ scripts) 🔒

Scripts that require GHES site-admin privileges.

| Pattern | Examples |
|---------|----------|
| `ghes-*.sh` | `ghes-get-settings.sh`, `ghes-list-license.sh` |
| `ghe-manage-v1-*.sh` | `ghe-manage-v1-get-the-ghes-settings.sh` |
| `create-user*.sh` | `create-user.sh`, `create-users.sh` |
| `suspend-a-user.sh` | 🔒 GHES only, ⚠️ destructive |
| `promote-*.sh` | `promote-a-user-to-be-a-site-administrator.sh` |

### Security features

| Script | Feature |
|--------|---------|
| `enable-secret-scanning.sh` | Enable secret scanning |
| `enable-push-protection.sh` | Enable push protection |
| `enable-dependabot-alerts.sh` | Enable Dependabot |
| `enable-code-scanning-default-setup.sh` | Enable CodeQL |
| `build-testcase-secret-scanning` | Full secret scanning scenario |
| `build-testcase-push-protection` | Full push protection scenario |

### GitHub CLI wrappers (67 scripts)

Scripts prefixed `gh-` that wrap `gh` CLI commands.

| Pattern | Examples |
|---------|----------|
| `gh-graphql-*.sh` | `gh-graphql-list-organization-repo-count.sh` |
| `gh-list-*.sh` | `gh-list-deploy-keys-on-org-repos.sh` |

## Safety labels

| Label | Meaning |
|-------|---------|
| ⚠️ DESTRUCTIVE | Permanently deletes resources. Cannot be undone. |
| ⚠️ BULK | Creates or deletes many resources at once. |
| 🔒 GHES only | Requires GitHub Enterprise Server admin API. |
| 🌐 Dotcom only | Designed for github.com, may not work on GHES. |

## Script anatomy

Every script follows the same pattern (see `skeleton.sh`):

1. Source config: `. ./.gh-api-examples.conf`
2. Accept optional positional arguments to override defaults
3. Build JSON payload with `jq -n` → write to `tmp/`
4. Call `curl` with bearer-token auth and API version header

## Finding scripts by API endpoint

Script names often match the REST API docs page title. For example:

- REST docs: "Create a repository" → `create-a-repository-for-the-authenticated-user.sh`
- REST docs: "List repository webhooks" → `list-repository-webhooks.sh`
- REST docs: "Get a pull request" → `get-a-pull-request.sh`

## Boundaries

- **Do not run destructive scripts without user confirmation.**
- **Do not run GHES-only scripts on dotcom.**
- **Do not run bulk scripts with high counts** without confirming with the user.
