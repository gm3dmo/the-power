.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/security-advisories/repository-advisories?apiVersion=2026-03-10#update-a-repository-security-advisory
# PATCH /repos/{owner}/{repo}/security-advisories/{ghsa_id}

ghsa_id=${1:-GHSA_ID}
repo=${2:-${repo}}
json_file=tmp/update-a-repository-security-advisory.json

jq -n \
     '{
       severity: "critical",
       state: "draft"
     }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/security-advisories/${ghsa_id}" --data @${json_file}
