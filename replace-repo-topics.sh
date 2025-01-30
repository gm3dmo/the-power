.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#replace-all-repository-topics
# PUT /repos/{owner}/{repo}/topics


names="topic-a"

json_file=tmp/replace_topics.json
jq -n \
                --arg names "${names}" \
                '{ names: [ $names ] }'  > ${json_file}


curl -X PUT ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/topics"  --data @${json_file}

