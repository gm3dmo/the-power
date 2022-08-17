. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#merge-a-pull-request
# PUT /repos/{owner}/{repo}/pulls/{pull_number}/merge


# If the script is passed an argument $1 use that as the pull number
if [ -z "$1" ]
  then
    pull_number=2
  else
    pull_number=$1
fi

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number}/merge
