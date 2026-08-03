.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/security-advisories/repository-advisories?apiVersion=2026-03-10#get-a-repository-security-advisory
# GET /repos/{owner}/{repo}/security-advisories/{ghsa_id}

ghsa_id=${1:-GHSA_ID}
repo=${2:-${repo}}

curl ${curl_custom_flags} \
     -X GET \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/security-advisories/${ghsa_id}"
