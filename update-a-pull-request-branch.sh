.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/pulls#update-a-pull-request-branch
# PUT /repos/{owner}/{repo}/pulls/{pull_number}/update-branch



json_file="update-a-pull-request-branch.json"

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.lydian-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pulls/${pull_number} --data @${json}
