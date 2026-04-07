---
name: run-script
description: >
  Execute any the-power script with guided parameter input. Covers
  prerequisites, working directory, output interpretation, HTTP status
  codes, error patterns, and debugging techniques.
keywords:
  - run
  - execute
  - script
  - output
  - HTTP
  - status
  - error
  - debug
  - curl
---

# Run Script

Execute scripts from the-power and interpret their output.

## Working directory

All scripts **must** be run from the root of a the-power repository clone
(the directory containing `build-testcase`, `configure.py`, and
`.gh-api-examples.conf`).

Find an existing clone:

```bash
find ~ -maxdepth 5 -name "build-testcase" -path "*/the-power/*" 2>/dev/null
```

## Prerequisites

1. **`.gh-api-examples.conf` must exist.** Generate with `python3 configure.py`.
2. **Required tools**: `jq`, `curl`, `python3`, `bash` 5.x.
3. **A valid PAT** configured in `.gh-api-examples.conf`.

## Before running

Verify the target org is accessible:

```bash
./get-an-organization.sh
```

If it returns 404, either create the org first (see `create-test-org`) or
use `build-all.sh`.

## How to run

### Orchestrated testcases

```bash
./build-testcase                       # repo with PR, issue, release
./build-testcase-workflow-simple       # GitHub Actions workflow
./build-testcase-secret-scanning       # secret scanning setup
```

### Individual scripts

```bash
./create-repo.sh                       # create a repository
./create-branch.sh                     # create a branch
./create-pull-request.sh               # open a pull request
./list-organization-members.sh         # list org members
./get-a-repo.sh                        # get repo details
```

Most scripts accept an optional positional argument to override the
default resource name:

```bash
./create-repo.sh my-custom-repo
./delete-repo.sh my-custom-repo
./list-team-members.sh my-team-slug
```

## Understanding output

### Success indicators

| HTTP status | Meaning |
|-------------|---------|
| 200 | Retrieved or updated successfully |
| 201 | Created successfully — look for `html_url` in the response |
| 204 | Deleted successfully (no content) |

### Failure patterns

| HTTP status | Meaning | Common cause |
|-------------|---------|--------------|
| 401 | Unauthorised | Token expired, invalid, or missing |
| 403 | Forbidden | Token lacks required scopes |
| 404 | Not Found | Resource does not exist, or token cannot see it |
| 422 | Validation Failed | Payload malformed or resource already exists |

### Example error

```json
{
  "message": "Validation Failed",
  "errors": [{"resource": "Repository", "field": "name",
              "message": "name already exists on this account"}]
}
```

## Verifying results

```bash
./list-repo.sh                         # repo details
./list-branches.sh                     # branches
./list-pull-requests.sh                # PRs
./list-repository-issues.sh            # issues
./list-repository-webhooks.sh          # webhooks
./get-branch-protection.sh             # branch protection rules
```

## Debugging

### Inspect JSON payloads

Scripts write request bodies to `tmp/` before sending:

```bash
cat tmp/create-pull-request.json | jq .
```

### Verbose curl

Set `curl_custom_flags` to `-v` for HTTP debugging:

```bash
python3 gh-set-value.py --key curl_custom_flags --value "-v"
```

### Base64 encoding

**Always use `python3 base64encode.py`** for base64 encoding. Never use
the native `base64` CLI tool — it behaves inconsistently across platforms.

## Error handling

- If a script fails silently, check `tmp/` for the JSON payload.
- If curl returns an empty response, check `curl_custom_flags` includes
  `--fail-with-body`.
- For SSL errors on GHES, see the `troubleshoot` skill.

## Boundaries

- **Do not run destructive scripts** (`delete-*`, `suspend-*`) without
  explicit user confirmation.
- **Do not display the full GITHUB_TOKEN.** Show only the first 8 characters.
- **Do not modify `.gh-api-examples.conf` directly** unless asked.
  Use `python3 gh-set-value.py` to change individual values.
- **Always confirm the target instance** before running scripts that
  create or delete resources.
