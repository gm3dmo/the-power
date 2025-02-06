.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/refs?apiVersion=2022-11-28#update-a-reference
# PATCH /repos/{owner}/{repo}/git/refs/{ref}

if [ -z "$1" ]
  then
    sha=${ref}
  else
    sha=$1
fi

json_file=tmp/update-a-reference.json

jq -n \
       --arg sha "${sha}" \
              '{ sha: $sha }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${base_branch}" --data @${json_file}

