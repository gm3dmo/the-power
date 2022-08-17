. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#list-organization-members
# GET /orgs/:org/members

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/members?role=admin
