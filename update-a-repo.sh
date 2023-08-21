. ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#update-a-repository
# PATCH /repos/{owner}/{repo}

json_file=tmp/update-a-repo.json
datestamp=$(date +%s)
description="description set by script at ${datestamp}"

rm -f ${json_file}

    jq -n \
           --arg description "${description}" \
           --arg delete_branch_on_merge  "true" \
           '{
             description: $description,
             delete_branch_on_merge: $delete_branch_on_merge | test("true")
           }' > ${json_file}

cat ${json_file} | jq -r

read x


curl --silent -v ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo} --data @${json_file}

rm -f ${json_file}
