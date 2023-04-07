.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#update-a-pull-request
# PATCH /repos/:owner/:repo/pulls/:pull_number

echo
echo    "Enter pull request number (or numbers) to change"
echo -n "Ie: 39    .. or multiples: 39 40 93 13:  "
read pull_request_list
echo

# List all the PR numbers you want to change
for pull_request in ${pull_request_list}
do
  curl ${curl_custom_flags} \
       -X PATCH \
       -H "Accept: application/vnd.github.v3+json" \
       -H "Authorization: Bearer ${GITHUB_TOKEN}" \
          ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_request} \
       --data  '{ "base": "main" }'
done 
