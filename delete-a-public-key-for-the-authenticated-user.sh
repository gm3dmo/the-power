.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/users/keys?apiVersion=2022-11-28#delete-a-public-ssh-key-for-the-authenticated-user
# DELETE /user/keys/{key_id}

key_id=${1:-'1'}

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user/keys/${key_id}"
