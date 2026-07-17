.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/users/attestations?apiVersion=2026-03-10#delete-attestations-by-id
# DELETE /users/{username}/attestations/{attestation_id}


# If the script is passed an argument $1 use that as the username
if [ -z "$1" ]
  then
    username=${admin_user}
  else
    username=$1
fi

# The attestation_id is passed as the second argument
attestation_id=$2


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: ******" \
        "${GITHUB_API_BASE_URL}/users/${username}/attestations/${attestation_id}"
