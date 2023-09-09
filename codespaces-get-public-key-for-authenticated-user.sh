.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/codespaces/secrets?apiVersion=2022-11-28#get-public-key-for-the-authenticated-user
# GET /user/codespaces/secrets/public-key


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user/codespaces/secrets/public-key"
