.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/self-hosted-runners?apiVersion=2022-11-28#list-labels-for-a-self-hosted-runner-for-an-organization
# GET /orgs/{org}/actions/runners/{runner_id}/labels


if [ -z "$1" ]
  then
    runner_id=1
  else
    runner_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/actions/runners/${runner_id}/labels"

