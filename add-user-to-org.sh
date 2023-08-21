.   ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#set-organization-membership-for-a-user
# PUT /orgs/:org/memberships/:username

org=${1:-$org}
person=${2}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${person}
