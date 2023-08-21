.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#update-a-repository
# PATCH /repos/{owner}/{repo}

timestamp=$(date +%s)
value="description udated at timestamp: ${timestamp}"

json_file=tmp/repo-details.json
rm -f ${json_file}

    jq -n \
           --arg value "${value}" \
           '{
             description: $value,
           }' > ${json_file}

>&2 cat ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo} --data @${json_file}

rm -f ${json_file}
