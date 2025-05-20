.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/releases/assets?apiVersion=2022-11-28#update-a-release-asset
# GET /repos/{owner}/{repo}/releases/assets/{asset_id}


if [ -z "$1" ]
  then
    asset_id=$(./list-release-assets.sh | jq '[.[].id] | max')
  else
    asset_id=$1
fi

name="foo-1.0.0-osx.zip"
label="Mac Binary The Power"

json_file=tmp/update-a-release-asset.sh
jq -n \
           --arg name "${name}" \
           --arg label "${label}" \
           '{
             name : $name,
             label : $label
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/releases/assets/${asset_id}" --data @${json_file}

