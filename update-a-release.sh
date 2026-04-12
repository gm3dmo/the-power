.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/releases/releases?apiVersion=2022-11-28#update-a-release
# PATCH /repos/{owner}/{repo}/releases/{release_id}


# If the script is passed an argument $1 use that as the release_id
if [ -z "$1" ]
  then
    release_id=$(./list-releases.sh | jq -r 'last.id')
  else
    release_id=$1
fi

name="Updated Release"
body="This release was updated by The Power."
draft="false"
prerelease="false"
make_latest="true"

json_file=tmp/update-a-release.json

jq -n \
       --arg name "${name}" \
       --arg body "${body}" \
       --arg draft "${draft}" \
       --arg prerelease "${prerelease}" \
       --arg make_latest "${make_latest}" \
       '{
         name : $name,
         body : $body,
         draft : $draft | test("true"),
         prerelease : $prerelease | test("true"),
         make_latest : $make_latest
       }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/releases/${release_id}" --data @${json_file}
