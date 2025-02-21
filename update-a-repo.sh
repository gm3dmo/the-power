. ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#update-a-repository
# PATCH /repos/{owner}/{repo}

json_file=tmp/update-a-repo.json
datestamp=$(date +%s)
description="description set by script at ${datestamp}"


    jq -n \
           --arg description "${description}" \
           --arg delete_branch_on_merge  "true" \
           '{
             description: $description,
             delete_branch_on_merge: $delete_branch_on_merge | test("true")
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}" --data @${json_file}

