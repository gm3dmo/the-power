.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/pulls?apiVersion=2022-11-28#update-a-pull-request
# PATCH /repos/{owner}/{repo}/pulls/{pull_number}


if [ -z "$1" ]
  then
    pull_number=${default_pull_request_id}
  else
    pull_number=$1
fi

state=open

json_file=tmp/update-a-pull-request.json
jq -n \
           --arg state "${state}" \
           '{
             state: $state,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}" --data @${json_file}

