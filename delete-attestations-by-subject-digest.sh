.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/users/attestations?apiVersion=2026-03-10#delete-attestations-by-subject-digest
# DELETE /users/{username}/attestations/digest/{subject_digest}


# If the script is passed an argument $1 use that as the username
if [ -z "$1" ]
  then
    username=${admin_user}
  else
    username=$1
fi

# If the script is passed an argument $2 use that as the subject_digest
subject_digest=${2:-sha256:abc123}


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: ******" \
        "${GITHUB_API_BASE_URL}/users/${username}/attestations/digest/${subject_digest}"
