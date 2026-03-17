# Creating Sub-Issues for the Sub-Issues API Endpoints

This directory contains a script to automatically create sub-issues for issue #236.

## Purpose

Create 5 sub-issues under issue #236 "Add support for sub issue REST API", one for each endpoint documented at:
https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28

## Prerequisites

Before running the script, you need to have:

1. A `.gh-api-examples.conf` file in the repository root with the following variables:
   ```bash
   owner="gm3dmo"
   repo="the-power"
   GITHUB_TOKEN="your_github_token_here"
   GITHUB_API_BASE_URL="https://api.github.com"
   github_api_version="2022-11-28"
   curl_custom_flags="--fail-with-body --no-progress-meter"
   ```

2. A GitHub Personal Access Token with the following permissions:
   - `repo` scope (for creating issues)
   - Access to the `gm3dmo/the-power` repository

3. The `jq` command-line JSON processor installed

## Running the Script

```bash
cd /home/runner/work/the-power/the-power
./tmp/create-sub-issues-for-endpoints.sh
```

## What the Script Does

For each of the 5 endpoints in the sub-issues API, the script will:

1. Create a new issue with:
   - Title: "Create script for {endpoint name} endpoint"
   - Body: Detailed requirements and template following `docs/script-generation-rules.md`
   - Label: "script-generation"

2. Link the new issue as a sub-issue to parent issue #236 using the GitHub sub-issues API

## Endpoints to be Created

1. **Get parent issue** - `GET /repos/{owner}/{repo}/issues/{issue_number}/parent`
2. **Remove sub-issue** - `DELETE /repos/{owner}/{repo}/issues/{issue_number}/sub_issue`
3. **List sub-issues** - `GET /repos/{owner}/{repo}/issues/{issue_number}/sub_issues`
4. **Add sub-issue** - `POST /repos/{owner}/{repo}/issues/{issue_number}/sub_issues` (already exists)
5. **Reprioritize sub-issue** - `PATCH /repos/{owner}/{repo}/issues/{issue_number}/sub_issues/priority`

## Manual Creation

If you prefer to create the issues manually, refer to `docs/create-sub-issues-plan.md` for the detailed plan and issue templates.

## Troubleshooting

### Configuration File Not Found

If you see an error about `.gh-api-examples.conf` not found, create it in the repository root with the required variables listed above.

### Rate Limiting

The script includes a 2-second delay between creating each issue to avoid rate limiting. If you encounter rate limit errors, increase this delay.

### Authentication Errors

Ensure your GitHub token has the correct permissions and hasn't expired.
