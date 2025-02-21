.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/secret-scanning/secret-scanning?apiVersion=2022-11-28#create-a-push-protection-bypass
# POST /repos/{owner}/{repo}/secret-scanning/push-protection-bypasses

# Use create-a-blob.sh to get a placeholder_id (for programmatic) or use the placeholder ids from the list when doing git push.

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    placeholder_id="bob"
  else
    placeholder_id=$1
fi

reason="will_fix_later"


json_file=tmp/create-a-push-protection-bypass.json
jq -n \
           --arg  reason "${reason}" \
           --arg  placeholder_id "${placeholder_id}" \
           '{
             reason: $reason, placeholder_id: $placeholder_id
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/secret-scanning/push-protection-bypasses"  --data @${json_file}

