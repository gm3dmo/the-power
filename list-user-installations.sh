.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/apps#list-app-installations-accessible-to-the-user-access-token
# GET /user/installations


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.machine-man-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/user/installations
