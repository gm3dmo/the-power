.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28#create-a-release
# POST /repos/:owner/:repo/releases

json_file=tmp/create-release.json
timestamp=$(date +%s)
draft="false"
prerelease="false"
generate_release_notes="true"

jq -n \
        --arg tag "v1.0.${timestamp}" \
        --arg commitish "${base_branch}" \
        --arg name "Release 1 ($timestamp)" \
        --arg prerelease ${prerelease} \
        --arg draft ${draft} \
        --arg generate_release_notes  ${generate_release_notes} \
        --arg body "The first and possibly last ever release." \
              '{tag_name : $tag, target_commitish: $commitish, name: $name, generate_release_notes: $generate_release_notes | test("true"), body: $body, draft: $draft | test("true"), prerelease: $prerelease | test("true")}'  > ${json_file}

#cat $json_file | jq -r >&2

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases --data @${json_file}

rm -f ${json_file}
