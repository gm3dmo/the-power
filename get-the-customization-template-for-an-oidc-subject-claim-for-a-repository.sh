.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/oidc#get-the-customization-template-for-an-oidc-subject-claim-for-a-repository
# GET /repos/{owner}/{repo}/actions/oidc/customization/sub

# You must authenticate using an access token with the repo scope to use this endpoint.

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/oidc/customization/sub"
