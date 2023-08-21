.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/activity#list-public-events-for-a-user
# GET /users/:username/events/public

username=${1:-hubot}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/users/${username}/events/public
