.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/releases/assets?apiVersion=2022-11-28#list-release-assets
# GET /repos/{owner}/{repo}/releases/{release_id}/assets


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    #release_id=$(./list-releases.sh | jq -r '.[] |.id | max')
    release_id=$(./list-releases.sh |  jq '[.[].id] | max')
  else
    release_id=$1
fi


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/releases/${release_id}/assets"

