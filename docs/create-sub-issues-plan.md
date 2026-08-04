# Plan: Create Sub-Issues for Sub-Issues API Endpoints

This document outlines the sub-issues that need to be created for implementing shell scripts for all endpoints in the GitHub REST API Sub-Issues documentation.

## Parent Issue
- Parent Issue Number: #236
- Parent Issue URL: https://github.com/gm3dmo/the-power/issues/236
- Parent Issue ID: 2792184665

## Sub-Issues to Create

Based on https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28

### 1. Get Parent Issue
- **Title**: Create script for Get parent issue endpoint
- **Endpoint**: GET `/repos/{owner}/{repo}/issues/{issue_number}/parent`
- **Script Name**: `get-parent-issue.sh`
- **Documentation**: https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#get-parent-issue

### 2. Remove Sub-Issue
- **Title**: Create script for Remove sub-issue endpoint
- **Endpoint**: DELETE `/repos/{owner}/{repo}/issues/{issue_number}/sub_issue`
- **Script Name**: `remove-sub-issue.sh`
- **Documentation**: https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#remove-sub-issue

### 3. List Sub-Issues
- **Title**: Create script for List sub-issues endpoint
- **Endpoint**: GET `/repos/{owner}/{repo}/issues/{issue_number}/sub_issues`
- **Script Name**: `list-sub-issues.sh`
- **Documentation**: https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#list-sub-issues

### 4. Add Sub-Issue
- **Title**: Create script for Add sub-issue endpoint
- **Endpoint**: POST `/repos/{owner}/{repo}/issues/{issue_number}/sub_issues`
- **Script Name**: `add-sub-issue.sh`
- **Documentation**: https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#add-sub-issue
- **Note**: This script already exists in the repository

### 5. Reprioritize Sub-Issue
- **Title**: Create script for Reprioritize sub-issue endpoint
- **Endpoint**: PATCH `/repos/{owner}/{repo}/issues/{issue_number}/sub_issues/priority`
- **Script Name**: `reprioritize-sub-issue.sh`
- **Documentation**: https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#reprioritize-sub-issue

## Issue Template

Each sub-issue should contain:

```markdown
Create a shell script `{script_name}` for the **{endpoint_name}** endpoint.

## Endpoint Details

- **Documentation**: {documentation_url}
- **HTTP Method**: {method}
- **Endpoint Path**: `{path}`
- **Script Filename**: `{script_name}`

## Requirements

Follow the rules in `docs/script-generation-rules.md`:

1. Source the configuration file: `. ./.gh-api-examples.conf`
2. Include documentation header with URL and endpoint path
3. Implement proper parameter validation
4. Use standard configuration variables
5. Follow the curl command structure with proper headers
6. Make script executable (`chmod +x`)
7. Follow consistent formatting (2-space indentation)
```

## Labels
- `script-generation`

## How to Create

Use the GitHub API or GitHub CLI to create these sub-issues and link them to the parent issue using the sub-issues API.
