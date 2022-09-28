. .gh-api-examples.conf


json_file=tmp/delete-branch-on-merge.json
rm -f ${json_file}

    jq -n \
           --arg dbom true \
           '{
             delete_branch_on_merge: $dbom | test("true"),
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo} --data @${json_file}

rm -f ${json_file}
