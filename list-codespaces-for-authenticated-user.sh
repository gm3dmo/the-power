.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/codespaces/codespaces?apiVersion=2022-11-28#list-codespaces-for-the-authenticated-user
# GET /user/codespaces


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/user/codespaces"

