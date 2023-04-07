.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#update-a-repository
# PATCH /repos/{owner}/{repo}

json_file=tmp/delete-branch-on-merge.json
rm -f ${json_file}

jq -n \
      --arg delete_branch_on_merge ${delete_branch_on_merge} \
           '{
             delete_branch_on_merge: $delete_branch_on_merge | test("true"),
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo} --data @${json_file}

