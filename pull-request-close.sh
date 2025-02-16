.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/pulls?apiVersion=2022-11-28#update-a-pull-request
# PATCH /repos/{owner}/{repo}/pulls/{pull_number}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    pull_number=${default_pull_request_id}
  else
    pull_nmber=$1
fi

state="closed"

json_file=tmp/update-a-pull-request.json
jq -n \
           --arg state "${state}" \
           '{
             state: $state,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}" --data  @${json_file}

