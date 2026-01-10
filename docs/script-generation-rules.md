# GitHub REST API Script Generation Rules

## Purpose
These rules define the standard pattern for creating shell scripts that interact with the GitHub REST API in "the-power-runtimes/teamperm" repository.

## Script Structure Template

### 1. Configuration Source
Every script MUST start by sourcing the configuration file:
```bash
.  ./.gh-api-examples.conf
```

### 2. Documentation Header
Include a comment block with:
- GitHub documentation URL for the endpoint
- HTTP method and endpoint path

Example:
```bash
# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/rules?apiVersion=2022-11-28#get-enterprise-ruleset-history
# GET /enterprises/{enterprise}/rulesets/{ruleset_id}/history
```

### 3. Parameter Handling

#### Required Parameters
If parameters are required, validate them and provide helpful error messages:
```bash
# If the script is passed an argument $1 use that as the parameter_name
if [ -z "$1" ]
  then
    echo "Error: parameter_name is required as first argument"
    exit 1
  else
    parameter_name=$1
fi
```

#### Optional Parameters with Defaults
If parameters are optional, provide fallback logic:
```bash
# If the script is passed an argument $1 use that as the parameter_name
if [ -z "$1" ]
  then
    parameter_name=$(./get-default-value.sh | jq '[.[].id] | max')
  else
    parameter_name=$1
fi
```

### 4. API Call Structure
Use curl with standard configuration variables:
```bash
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/path/to/endpoint"
```

### 5. File Naming Convention

Pattern: `{action}-{resource}.sh`

Examples by scope:
- **Repository**: `get-a-repository-ruleset.sh`, `create-a-repository-secret.sh`
- **Organization**: `get-an-organization-repository-ruleset.sh`, `list-organization-members.sh`
- **Enterprise**: `get-enterprise-ruleset-history.sh`, `list-enterprise-teams.sh`

## Standard Configuration Variables

Use these variables from `.gh-api-examples.conf`:

### Authentication
- `${GITHUB_TOKEN}` - Personal access token or app token
- `${github_api_version}` - API version (2022-11-28)

### Base URLs
- `${GITHUB_API_BASE_URL}` - REST API base URL (https://api.github.com)
- `${GITHUB_APIV4_BASE_URL}` - GraphQL API base URL

### Scope Variables
- `${enterprise}` - Enterprise slug
- `${org}` or `${owner}` - Organization name
- `${repo}` - Repository name
- `${team_slug}` - Team slug

### Other Common Variables
- `${curl_custom_flags}` - Standard curl flags (--fail-with-body --no-progress-meter)

## HTTP Method Patterns

### GET Requests
```bash
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/endpoint"
```

### POST Requests
```bash
json_payload=$(cat <<EOF
{
  "key": "value"
}
EOF
)

curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/endpoint" \
     -d "${json_payload}"
```

### PATCH/PUT Requests
```bash
curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/endpoint" \
     -d '{"key": "value"}'
```

### DELETE Requests
```bash
curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/endpoint"
```

## Script Formatting Rules

1. **Indentation**: Use 2 spaces for indentation in if/then blocks
2. **Blank Lines**: Add blank lines between major sections for readability
3. **Comments**: Include comments for parameter handling logic
4. **Trailing Newline**: Always end files with a blank line
5. **Executable**: Scripts must be executable (`chmod +x`)

## Common Patterns by Resource Type

### Repository Scripts
```bash
.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/...
# METHOD /repos/{owner}/{repo}/...

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/endpoint"
```

### Organization Scripts
```bash
.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/...
# METHOD /orgs/{org}/...

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/endpoint"
```

### Enterprise Scripts
```bash
.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/...
# METHOD /enterprises/{enterprise}/...

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/endpoint"
```

## Examples

### Example 1: Simple GET with Required Parameter
```bash
.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/rules?apiVersion=2022-11-28#get-enterprise-ruleset-history
# GET /enterprises/{enterprise}/rulesets/{ruleset_id}/history


# If the script is passed an argument $1 use that as the ruleset_id
if [ -z "$1" ]
  then
    echo "Error: ruleset_id is required as first argument"
    exit 1
  else
    ruleset_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/rulesets/${ruleset_id}/history"
```

### Example 2: GET with Optional Parameter and Default
```bash
.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/rules?apiVersion=2022-11-28#get-repository-ruleset-history
# GET /repos/{owner}/{repo}/rulesets/{ruleset_id}/history


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    ruleset_id=$(./get-all-repository-rulesets.sh | jq '[.[].id] | max')
  else
    ruleset_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/rulesets/${ruleset_id}/history"
```

## Checklist for New Scripts

- [ ] Script sources `.gh-api-examples.conf`
- [ ] Documentation URL is correct and complete
- [ ] HTTP method and endpoint path are documented
- [ ] Parameters are validated with appropriate error messages
- [ ] Configuration variables are used (not hardcoded values)
- [ ] Curl command includes all standard headers
- [ ] File naming follows convention
- [ ] Script is executable (`chmod +x`)
- [ ] Formatting uses consistent indentation (2 spaces)
- [ ] File ends with a blank line
