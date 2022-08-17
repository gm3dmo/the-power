. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#create-an-organization-invitation
# POST /orgs/{org}/invitations

invitation_id=$1

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/invitations/${invitation_id}
