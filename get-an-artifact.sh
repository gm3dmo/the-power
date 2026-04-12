.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/actions/artifacts?apiVersion=2022-11-28#get-an-artifact
# GET /repos/{owner}/{repo}/actions/artifacts/{artifact_id}

# If the script is passed an argument $1 use that as the artifact_id
if [ -z "$1" ]
  then
    artifact_id=$(./list-artifacts-for-a-repository.sh | jq -r '.artifacts[-1].id')
  else
    artifact_id=$1
fi

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/artifacts/${artifact_id}"
