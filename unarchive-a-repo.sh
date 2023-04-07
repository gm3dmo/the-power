.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/repos#update-a-repository
# PATCH /repos/{owner}/{repo}

json_file=tmp/update-a-repo.json
datestamp=$(date +%s)
description="unarchived by an archiving script at timestamp: ${datestamp}"

rm -f ${json_file}

    jq -n \
           --arg description "${description}" \
           --arg archived "false" \
           '{
             description: $description,
             archived: $archived
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo} --data @${json_file}

rm -f ${json_file}
