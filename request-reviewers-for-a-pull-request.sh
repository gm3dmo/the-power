.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pulls/review-requests?apiVersion=2022-11-28#request-reviewers-for-a-pull-request
# POST /repos/{owner}/{repo}/pulls/{pull_number}/requested_reviewers


if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

reviewer=${default_committer}
pull_number=${default_pull_request_id}

json_file=tmp/request-reviewers-for-a-pull-request.json
jq -n \
           --arg reviewer "${reviewer}" \
           '{
             reviewers : [ $reviewer ]
           }' > ${json_file}


curl -v ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/requested_reviewers" --data @${json_file}


