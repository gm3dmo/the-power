.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/activity/events?apiVersion=2022-11-28#list-repository-events
# GET /repos/{owner}/{repo}/events

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/events"

