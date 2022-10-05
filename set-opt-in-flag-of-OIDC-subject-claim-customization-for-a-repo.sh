. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/oidc#set-the-opt-in-flag-of-an-oidc-subject-claim-customization-for-a-repository
# PUT /repos/{owner}/{repo}/actions/oidc/customization/sub
# You must authenticate using an access token with the repo scope to use this endpoint.

use_default=$1

if [ "$use_default" == "true" ]
then
    curl ${curl_custom_flags} \
        -X PUT \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/oidc/customization/sub -d '{"use_default":true}'
elif [ "$use_default" == "false" ]
then
    curl ${curl_custom_flags} \
        -X PUT \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/oidc/customization/sub -d '{"use_default":false}'
else
  echo "You must pass either 'true' or 'false' as an argument to this script."
fi