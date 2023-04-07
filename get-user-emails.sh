.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/users#list-email-addresses-for-the-authenticated-user
# GET /user/emails

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/user/emails
