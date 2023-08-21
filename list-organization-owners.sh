.  ./.gh-api-examples.conf

# https://docs.github.com/en/free-pro-team@latest/rest/orgs/members?apiVersion=2022-11-28#list-organization-members
# GET /orgs/{org}/members

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/members?role=admin
