.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-a-release
# POST /repos/:owner/:repo/releases

json_file=tmp/create-release.json
timestamp=$(date +%s)

rm -f ${json_file}

jq -n \
        --arg tag "tag_fixedTest3" \
        --arg commitish "${base_branch}" \
        --arg name "Release 1 ($timestamp)" \
        --arg body "The first and possibly last ever release." \
              '{tag_name : $tag, target_commitish: $commitish, name: $name, body: $body }'  > ${json_file}

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases --data @${json_file}

rm -f ${json_file}
