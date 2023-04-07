.  ./.gh-api-examples.conf


default_branch="dev"

json_file=tmp/repo-details.json
rm -f ${json_file}

    jq -n \
           --arg default_branch ${default_branch} \
           '{
             default_branch: $default_branch,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo} --data @${json_file}

rm -f ${json_file}
