.   ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/collaborators/collaborators?apiVersion=2022-11-28#list-repository-collaborators
# GET /repos/{owner}/{repo}/collaborators


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/collaborators"

