.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/releases/releases?apiVersion=2022-11-28#create-a-release
# POST /repos/{owner}/{repo}/releases


timestamp=$(date +%s)
draft="false"
prerelease="false"
generate_release_notes="true"

# The power default to having discussions enabled so you might need to handle this:
discussion_category_name="Announcements"

if [ -z "$1" ]
  then
    tag="v1.0.${timestamp}" 
  else
    tag=$1
fi


json_file=tmp/create-release.json

jq -n \
        --arg tag "v1.0.${timestamp}" \
        --arg commitish "${base_branch}" \
        --arg name "Release 1 ($timestamp)" \
        --arg prerelease ${prerelease} \
        --arg draft ${draft} \
        --arg discussion_category_name ${discussion_category_name} \
        --arg generate_release_notes  ${generate_release_notes} \
        --arg body "A release created by The Power." \
              '{tag_name : $tag, target_commitish: $commitish, name: $name, generate_release_notes: $generate_release_notes | test("true"), body: $body, draft: $draft | test("true"), prerelease: $prerelease | test("true"), discussion_category_name: $discussion_category_name}'  > ${json_file}

#cat $json_file | jq -r >&2

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases" --data @${json_file}

rm -f ${json_file}
