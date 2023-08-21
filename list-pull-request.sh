.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#get-a-pull-request
# GET /repos/:owner/:repo/pulls/:pull_number

if [ -z "$1" ]
  then
    pull_number=$default_pull_request_id
  else
    pull_number=$1
fi



curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.shadow-cat-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}
