.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/codespaces/codespaces#list-codespaces-for-the-authenticated-user
# GET /user/codespaces

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/user/codespaces