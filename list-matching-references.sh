.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/refs?apiVersion=2022-11-28
# GET /repos/{owner}/{repo}/git/matching-refs/{ref}


ref="heads/$1"



set -x
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/git/refs/${ref}"
