.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#update-a-reference
# PATCH /repos/{owner}/{repo}/git/refs/{ref}

if [ -z "$1" ]
  then
    sha=$(cat tmp/pre-receive-new-commit-response.json | jq -r '.sha')
  else
    sha=$1
fi

json_file=tmp/create-commit.json
rm -f ${json_file}

repo=${pre_receive_hook_repo}

jq -n \
       --arg sha "${sha}" \
              '{ sha: $sha }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${base_branch} --data @${json_file}
