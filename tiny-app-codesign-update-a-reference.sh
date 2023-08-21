.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#update-a-reference
# PATCH /repos/{owner}/{repo}/git/refs/{ref}


GITHUB_TOKEN=$1
sha=$(cat tmp/tiny-app-codesign-create-a-commit-response.json | jq -r '.sha')
json_file=tmp/create-commit.json


jq -n \
       --arg sha "${sha}" \
              '{ sha: $sha }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${base_branch} --data @${json_file}

