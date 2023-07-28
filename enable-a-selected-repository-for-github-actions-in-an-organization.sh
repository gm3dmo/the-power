.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/permissions?apiVersion=2022-11-28#enable-a-selected-repository-for-github-actions-in-an-organization
# PUT /orgs/{org}/actions/permissions/repositories/{repository_id}

repository_id=$(./list-repo.sh  ${repo}  | jq '.id')

curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/actions/permissions/repositories/${repository_id}"
