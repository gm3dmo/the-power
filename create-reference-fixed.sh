.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/refs?apiVersion=2022-11-28#create-a-reference
# POST /repos/{owner}/{repo}/git/refs


sha=592ad0eaa885f0131f5a0b3f212fe531eec4a2af
ref=refs/tags/tag_fixedTest3

json_file=tmp/create-reference.json
jq -n \
                --arg ref "${ref}" \
                --arg sha "${sha}" \
                '{ ref: $ref,
                  sha: $sha }'  > ${json_file}

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs" --data @${json_file}

