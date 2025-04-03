.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/webhooks?apiVersion=2022-11-28#update-a-repository-webhook
# PATCH /repos/{owner}/{repo}/hooks/{hook_id}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    hook_id=$(./list-repository-webhooks.sh | jq '[.[].id] | max')
  else
    hook_id=$1
fi

active=true

json_file=tmp/update-a-repository-webhook.json
jq -n \
           --arg active "${active}" \
           '{
             active: $active | test("true"),
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/hooks/${hook_id}"  --data @${json_file}

