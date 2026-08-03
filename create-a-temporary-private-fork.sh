.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/security-advisories/repository-advisories?apiVersion=2026-03-10#create-a-temporary-private-fork
# POST /repos/{owner}/{repo}/security-advisories/{ghsa_id}/forks

ghsa_id=${1:-GHSA_ID}
repo=${2:-${repo}}

curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/security-advisories/${ghsa_id}/forks"
