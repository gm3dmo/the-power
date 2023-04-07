.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#update-a-pull-request
# PATCH /repos/:owner/:repo/pulls/:pull_number

pull_number=2

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number} \
      --data  '{ "state": "closed" }'
