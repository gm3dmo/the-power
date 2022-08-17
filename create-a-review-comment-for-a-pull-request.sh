. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#create-a-review-comment-for-a-pull-request
# POST /repos/{owner}/{repo}/pulls/{pull_number}/comments


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=${default_pull_request_id}
  else
    pull_number=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/comments
