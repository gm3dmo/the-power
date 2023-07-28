.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/permissions?apiVersion=2022-11-28#set-github-actions-permissions-for-a-repository
# PUT /repos/{owner}/{repo}/actions/permissions

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

json_file=tmp/set-github-actions-permissions-for-a-repository.json

enabled="true"
allowed_actions="selected"

jq -n \
           --arg enabled ${enabled} \
           --arg allowed_actions "${allowed_actions}" \
           '{
	      enabled : $enabled | test("true"),
              allowed_actions : $allowed_actions
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/actions/permissions"  --data @${json_file}
