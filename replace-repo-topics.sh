.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#replace-all-repository-topics
# PUT /repos/{owner}/{repo}/topics


json_file=tmp/replace_topics.json
names="topic-a"

rm -f ${json_file}

jq -n \
                --arg names "${names}" \
                '{ names: [ $names ] }'  > ${json_file}

cat ${json_file} | jq -r

set -x
curl -X PUT ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.mercy-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/topics  --data @${json_file}
