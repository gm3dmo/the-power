.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/metrics/traffic?apiVersion=2022-11-28#get-repository-clones
# GET /repos/{owner}/{repo}/traffic/clones


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/traffic/clones"

