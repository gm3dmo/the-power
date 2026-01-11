# Instructions for Creating Sub-Issues

## Task

Create 5 sub-issues under issue #236 in the gm3dmo/the-power repository. Each sub-issue should represent one endpoint from the GitHub REST API Sub-Issues documentation.

## Parent Issue

- **Issue Number**: #236
- **Issue ID**: 2792184665  
- **Title**: "Add support for sub issue REST API"
- **URL**: https://github.com/gm3dmo/the-power/issues/236

## Sub-Issues to Create

### 1. Get Parent Issue
```markdown
**Title**: Create script for Get parent issue endpoint

**Body**:
Create a shell script `get-parent-issue.sh` for the **Get parent issue** endpoint.

## Endpoint Details

- **Documentation**: https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#get-parent-issue
- **HTTP Method**: GET
- **Endpoint Path**: `/repos/{owner}/{repo}/issues/{issue_number}/parent`
- **Script Filename**: `get-parent-issue.sh`

## Requirements

Follow the rules in `docs/script-generation-rules.md`:

1. Source the configuration file: `. ./.gh-api-examples.conf`
2. Include documentation header with URL and endpoint path
3. Implement proper parameter validation
4. Use standard configuration variables
5. Follow the curl command structure with proper headers
6. Make script executable (`chmod +x`)
7. Follow consistent formatting (2-space indentation)

**Labels**: script-generation
```

### 2. Remove Sub-Issue
```markdown
**Title**: Create script for Remove sub-issue endpoint

**Body**:
Create a shell script `remove-sub-issue.sh` for the **Remove sub-issue** endpoint.

## Endpoint Details

- **Documentation**: https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#remove-sub-issue
- **HTTP Method**: DELETE
- **Endpoint Path**: `/repos/{owner}/{repo}/issues/{issue_number}/sub_issue`
- **Script Filename**: `remove-sub-issue.sh`

## Requirements

Follow the rules in `docs/script-generation-rules.md`:

1. Source the configuration file: `. ./.gh-api-examples.conf`
2. Include documentation header with URL and endpoint path
3. Implement proper parameter validation (issue_number and sub_issue_id)
4. Use standard configuration variables
5. Follow the curl command structure with proper headers
6. Make script executable (`chmod +x`)
7. Follow consistent formatting (2-space indentation)

**Labels**: script-generation
```

### 3. List Sub-Issues
```markdown
**Title**: Create script for List sub-issues endpoint

**Body**:
Create a shell script `list-sub-issues.sh` for the **List sub-issues** endpoint.

## Endpoint Details

- **Documentation**: https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#list-sub-issues
- **HTTP Method**: GET
- **Endpoint Path**: `/repos/{owner}/{repo}/issues/{issue_number}/sub_issues`
- **Script Filename**: `list-sub-issues.sh`

## Requirements

Follow the rules in `docs/script-generation-rules.md`:

1. Source the configuration file: `. ./.gh-api-examples.conf`
2. Include documentation header with URL and endpoint path
3. Implement proper parameter validation
4. Use standard configuration variables
5. Follow the curl command structure with proper headers
6. Make script executable (`chmod +x`)
7. Follow consistent formatting (2-space indentation)

**Labels**: script-generation
```

### 4. Add Sub-Issue
```markdown
**Title**: Create script for Add sub-issue endpoint

**Body**:
Create a shell script `add-sub-issue.sh` for the **Add sub-issue** endpoint.

## Endpoint Details

- **Documentation**: https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#add-sub-issue
- **HTTP Method**: POST
- **Endpoint Path**: `/repos/{owner}/{repo}/issues/{issue_number}/sub_issues`
- **Script Filename**: `add-sub-issue.sh`

**Note**: This script already exists in the repository. This issue is for documentation purposes and to ensure it follows the current script generation rules.

## Requirements

Follow the rules in `docs/script-generation-rules.md`:

1. Source the configuration file: `. ./.gh-api-examples.conf`
2. Include documentation header with URL and endpoint path
3. Implement proper parameter validation
4. Use standard configuration variables
5. Follow the curl command structure with proper headers
6. Make script executable (`chmod +x`)
7. Follow consistent formatting (2-space indentation)

**Labels**: script-generation
```

### 5. Reprioritize Sub-Issue
```markdown
**Title**: Create script for Reprioritize sub-issue endpoint

**Body**:
Create a shell script `reprioritize-sub-issue.sh` for the **Reprioritize sub-issue** endpoint.

## Endpoint Details

- **Documentation**: https://docs.github.com/en/enterprise-cloud@latest/rest/issues/sub-issues?apiVersion=2022-11-28#reprioritize-sub-issue
- **HTTP Method**: PATCH
- **Endpoint Path**: `/repos/{owner}/{repo}/issues/{issue_number}/sub_issues/priority`
- **Script Filename**: `reprioritize-sub-issue.sh`

## Requirements

Follow the rules in `docs/script-generation-rules.md`:

1. Source the configuration file: `. ./.gh-api-examples.conf`
2. Include documentation header with URL and endpoint path
3. Implement proper parameter validation (issue_number, sub_issue_id, after_id or before_id)
4. Use standard configuration variables
5. Follow the curl command structure with proper headers
6. Make script executable (`chmod +x`)
7. Follow consistent formatting (2-space indentation)

**Labels**: script-generation
```

## How to Create These Issues

### Option 1: Using GitHub Web Interface
1. Go to https://github.com/gm3dmo/the-power/issues/new
2. For each sub-issue above, create a new issue with the title and body provided
3. Add the "script-generation" label
4. After creating each issue, use the sub-issues API or UI to link it to parent issue #236

### Option 2: Using the Automated Script
If you have a `.gh-api-examples.conf` file configured with GITHUB_TOKEN, run:
```bash
cd /home/runner/work/the-power/the-power
./tmp/create-sub-issues-for-endpoints.sh
```

### Option 3: Using GitHub CLI
```bash
# Create each issue and link it to parent #236
gh issue create --title "Create script for Get parent issue endpoint" --body-file <(cat <<'EOF'
[paste body from above]
EOF
) --label "script-generation" --repo gm3dmo/the-power
```

## After Creating Issues

Once all 5 sub-issues are created, they need to be linked to parent issue #236 using the GitHub sub-issues API:

```bash
# For each created issue, get its ID and run:
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer <YOUR-TOKEN>" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/gm3dmo/the-power/issues/236/sub_issues \
  -d '{"sub_issue_id":<ISSUE_ID>}'
```
