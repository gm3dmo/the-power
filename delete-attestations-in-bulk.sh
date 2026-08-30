.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/users/attestations?apiVersion=2026-03-10#delete-attestations-in-bulk
# POST /users/{username}/attestations/delete-request


# If the script is passed an argument $1 use that as the username
if [ -z "$1" ]
  then
    username=${admin_user}
  else
    username=$1
fi


json_file=tmp/delete-attestations-in-bulk.json

jq -n \
       --arg digest1 "sha256:abc123" \
       --arg digest2 "sha512:def456" \
       '{
         subject_digests: [ $digest1, $digest2 ]
       }' > ${json_file}


curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: ******" \
        "${GITHUB_API_BASE_URL}/users/${username}/attestations/delete-request" --data @${json_file}
