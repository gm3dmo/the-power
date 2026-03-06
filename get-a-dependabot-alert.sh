.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/dependabot/alerts?apiVersion=2022-11-28#get-a-dependabot-alert
# /repos/{owner}/{repo}/dependabot/alerts/{alert_number}


    alert_number=${1:-1}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/dependabot/alerts/${alert_number}"

