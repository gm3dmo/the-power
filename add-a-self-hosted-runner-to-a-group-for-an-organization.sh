.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/self-hosted-runner-groups?apiVersion=2022-11-28#add-a-self-hosted-runner-to-a-group-for-an-organization
# PUT /orgs/{org}/actions/runner-groups/{runner_group_id}/runners/{runner_id}

#runner_group_id=$(./list-self-hosted-runner-groups-for-an-organization.sh | jq '.runner_groups[-1].id')
runner_group_id=$(./list-self-hosted-runner-groups-for-an-organization.sh | jq '.runner_groups[0].id')
runner_id=$(./list-self-hosted-runners-for-an-organization.sh | jq '.runners[-1].id')

set -x
curl -v ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/actions/runner-groups/${runner_group_id}/runners/${runner_id}"

