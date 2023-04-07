.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/users#delete-a-gpg-key-for-the-authenticated-user
# DELETE /user/gpg_keys/{gpg_key_id}

key_id=${1:-'1'}

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/user/gpg_keys/${key_id}
