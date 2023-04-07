.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.5/rest/releases/releases#generate-release-notes-content-for-a-release
# POST /repos/{owner}/{repo}/releases/generate-notes 

json_file=tmp/create-release.json
timestamp=$(date +%s)
previous_tag_name=""
generate_release_notes="true"

jq -n \
        --arg tag_name "v1.0.${timestamp}" \
              '{tag_name : $tag_name}'  > ${json_file}

cat $json_file | jq -r >&2

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases/generate-notes --data @${json_file}
