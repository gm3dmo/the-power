.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-reference
# POST /repos/:owner/:repo/git/refs

tag_sha=$(./create-tag.sh | jq -r '.sha')

ref=refs/tags/tag_fixedTest7

json_file=tmp/create-reference.json

rm -f ${json_file}

jq -n \
                --arg ref "${ref}" \
                --arg sha "${tag_sha}" \
                '{ ref: $ref,
                  sha: $sha }'  > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs --data @${json_file}

rm -f ${json_file}
