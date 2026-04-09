# the-power — Copilot CLI Plugin

Skills and safety hooks for [the-power](https://github.com/gm3dmo/the-power), a lightweight GitHub API test environment framework.

## What this plugin does

- **Finds scripts** — the-power has ~980 scripts across dozens of categories. The plugin helps agents discover the right one by keyword, category, or goal.
- **Guides execution** — walks agents through configuration, prerequisites, and parameter selection before running scripts.
- **Creates test environments** — orchestrates org, repo, and resource creation using the-power's build-testcase scripts.
- **Enforces guardrails** — hooks that block destructive operations, warn on high-count bulk creation, and flag classic PATs on github.com.
- **Cleans up** — guides teardown of test resources when done.

## Install

Install directly from gm3dmo/the-power:

```bash
copilot plugin install gm3dmo/the-power:copilot-plugin
```

Or install from a local checkout:

```bash
copilot plugin install /path/to/the-power/copilot-plugin
```

## Skills

| Skill | Description |
|-------|-------------|
| `configure` | Set up `.gh-api-examples.conf` for a target GitHub instance |
| `create-test-org` | Spin up a fully populated test organisation with users, teams, and repos |
| `create-test-repo` | Create a test repository with PRs, issues, branch protection, and more |
| `discover-scripts` | Find scripts by category, keyword, or goal |
| `run-script` | Execute any the-power script with guided parameter input |
| `setup-github-app` | Register, configure, and install a GitHub App for App-based authentication |
| `scale-environment` | Bulk-create repos, users, orgs, and teams with three performance tiers |
| `cleanup-test-data` | Remove test organisations, repos, and other resources |
| `troubleshoot` | Diagnose SSL, token, HTTP, and configuration issues |

## Hooks (guardrails)

| Hook | What it guards |
|------|---------------|
| `guard-destructive-ops` | Blocks `delete-*`, `suspend-*`, `archive-*`, `remove-*`, and `transfer-*` scripts without explicit user confirmation |
| `guard-scaling-ops` | Warns when bulk-creation scripts use counts over 100 |
| `guard-token-scope` | Warns when a classic PAT (`ghp_`) is used against github.com |

## Prerequisites

the-power itself requires:

- bash 5.x (macOS ships 3.2 — install via `brew install bash`)
- jq
- curl
- Python 3.6+
- A personal access token for the target GitHub instance

See [docs/setup.md](../docs/setup.md) for full details.

## Related

- [github/support#2560](https://github.com/github/support/issues/2560) — AI Initiative issue
- [github/cs-boot#32](https://github.com/github/cs-boot/issues/32) — Similar plugin for cs-boot instances
- [the-power documentation](https://gm3dmo.github.io/the-power/)
