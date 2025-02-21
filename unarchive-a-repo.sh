.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#update-a-repository
# PATCH /repos/{owner}/{repo}


datestamp=$(date +%s)
description="unarchived by an archiving script at timestamp: ${datestamp}"

json_file=tmp/update-a-repo.json
jq -n \
       --arg description "${description}" \
       --arg archived "false" \
           '{
             description: $description,
             archived: $archived
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}" --data @${json_file}

