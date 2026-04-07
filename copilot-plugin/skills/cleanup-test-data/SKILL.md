---
name: cleanup-test-data
description: >
  Clean up GitHub resources created by the-power test environment scripts.
  Delete repositories, teams, members, rulesets, webhooks, environments,
  and other resources. Suspend or unsuspend users on GHES.
keywords:
  - cleanup
  - delete
  - remove
  - destroy
  - teardown
  - suspend
  - unsuspend
---

# Cleanup Test Data

Remove resources created by the-power scripts.

## Working directory

All cleanup scripts **must** be run from the root of a the-power clone.

Find an existing clone:

```bash
find ~ -maxdepth 5 -name "delete-repo.sh" -path "*/the-power/*" 2>/dev/null
```

## Safety warnings

- **Deletions are IRREVERSIBLE.** There is no undo.
- Always verify `.gh-api-examples.conf` points at the correct server.
- Review the target `org` and `repo` values before deleting.
- GHES-only operations (suspend/unsuspend) will not work on github.com.

## Quick cleanup: delete the org

The fastest way to clean up everything is to delete the entire org:

```bash
curl -X DELETE \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  "${GITHUB_API_BASE_URL}/orgs/${org}"
```

This removes the org and all its repos, teams, and other resources.

## Cleanup by category

### Repositories

| Script | Description |
|--------|-------------|
| `delete-repo.sh [repo]` | Delete a repository from `${org}` |
| `delete-a-file.sh` | Delete a single file |

### Teams

| Script | Description |
|--------|-------------|
| `delete-team.sh <team_slug>` | Delete a team |
| `delete-many-teams.sh` | Delete all teams in `nato-alphabet.txt` |
| `delete-team-member.sh` | Remove a team member |

### Branch protection and rulesets

| Script | Description |
|--------|-------------|
| `delete-branch-protection.sh` | Remove branch protection |
| `delete-a-repository-ruleset.sh` | Delete a repo ruleset |
| `delete-an-organization-repository-ruleset.sh` | Delete an org ruleset |

### Webhooks

| Script | Description |
|--------|-------------|
| `delete-webhook.sh` | Delete a repo webhook |
| `delete-an-organization-webhook.sh` | Delete an org webhook |

### Environments

| Script | Description |
|--------|-------------|
| `delete-environment.sh [env] [repo]` | Delete an environment |
| `delete-a-deployment.sh` | Delete a deployment |

### Secrets and keys

| Script | Description |
|--------|-------------|
| `delete-an-organization-secret.sh` | Delete an org secret |
| `delete-a-repository-variable.sh` | Delete a repo variable |
| `delete-a-deploy-key.sh` | Delete a deploy key |

### Other

| Script | Description |
|--------|-------------|
| `delete-a-release-asset.sh` | Delete a release asset |
| `delete-a-milestone.sh` | Delete a milestone |
| `delete-a-reference.sh` | Delete a git reference |
| `delete-a-code-scanning-analysis-from-a-repository.sh` | Delete a code scanning analysis |

## GHES-only: suspend and unsuspend users

| Script | Description |
|--------|-------------|
| `suspend-a-user.sh [username]` | Suspend a user on GHES |
| `unsuspend-a-user.sh [username]` | Unsuspend a user on GHES |

## Examples

```bash
./delete-repo.sh my-test-repo              # delete a specific repo
./delete-team.sh alpha                      # delete a team
./delete-environment.sh staging my-repo     # delete an environment
./suspend-a-user.sh testuser               # suspend a GHES user
```

## Error handling

- **404** — resource does not exist or was already deleted.
- **403** — token lacks `delete_repo` or `admin:org` scope.
- **422** — resource has dependencies that prevent deletion.

## Boundaries

- **Always confirm with the user** before running any delete script.
- **Verify the target instance** — check `hostname` and `org` values.
- **Do not delete resources you did not create** on shared instances.
- **Do not display the GITHUB_TOKEN.** Show only the first 8 characters.
