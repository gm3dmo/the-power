.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/commits/comments?apiVersion=2022-11-28#create-a-commit-comment
# POST /repos/{owner}/{repo}/commits/{commit_sha}/comments


commit_sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/ref/heads/${base_branch}| jq -r '.object.sha')
lorem=$(cat test-data/lorem.txt)
body="${lorem}"


json_file=tmp/create-a-commit-comment.json
jq -n \
        --arg body "${body}" \
          '{ body: $body
             }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits/${commit_sha}/comments" --data @${json_file}

