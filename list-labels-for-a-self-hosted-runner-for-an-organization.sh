.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#list-labels-for-a-self-hosted-runner-for-an-organization
# GET /orgs/{org}/actions/runners/{runner_id}/labels


# If the script is passed an argument $1 use that as the runner_id
if [ -z "$1" ]
  then
    runner_id=1
  else
    runner_id=$1
fi



curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/actions/runners/${runner_id}/labels
