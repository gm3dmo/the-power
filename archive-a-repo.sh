.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#update-a-repository
# PATCH /repos/{owner}/{repo}

datestamp=$(date +%s)
description="archived by an archiving script at timestamp: ${datestamp}"


json_file=tmp/update-a-repo.json
jq -n \
       --arg description "${description}" \
       --arg archived "true" \
            '{
             description: $description,
             archived: $archived
         }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}" --data @${json_file}

