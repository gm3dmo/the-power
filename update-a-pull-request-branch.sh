.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/pulls?apiVersion=2022-11-28#update-a-pull-request-branch
# PUT /repos/{owner}/{repo}/pulls/{pull_number}/update-branch

# If the script is passed an argument $1 use that as the pull number
if [ -z "$1" ]
  then
    pull_number=1
  else
    pull_number=$1
fi

json_file=tmp/update-a-pull-request-branch.json

jq -n \
           --arg expected_head_sha "${expected_head_sha}" \
           '{
             expected_head_sha : $expected_head_sha,
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/update-branch" --data @${json_file}

