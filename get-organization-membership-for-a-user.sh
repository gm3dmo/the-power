.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.2/rest/reference/orgs#get-organization-membership-for-a-user
# GET /orgs/{org}/memberships/{username}

if [ -z "$1" ]
  then
    username=${default_committer}
  else
    username=${1}
fi


set -x
curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${username}
