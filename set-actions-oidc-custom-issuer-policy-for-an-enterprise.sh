. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/oidc#set-the-github-actions-oidc-custom-issuer-policy-for-an-enterprise
# PUT /enterprises/{enterprise}/actions/oidc/customization/issuer
# You must authenticate using an access token with the admin:enterprise scope to use this endpoint. 

include_enterprise_slug=$1

if [ "$include_enterprise_slug" == "true" ]
then
    curl ${curl_custom_flags} \
        -X PUT \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/enterprises/${enterprise}/actions/oidc/customization/issuer -d '{"include_enterprise_slug":true}'
elif [ "$include_enterprise_slug" == "false" ]
then
    curl ${curl_custom_flags} \
        -X PUT \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/enterprises/${enterprise}/actions/oidc/customization/issuer -d '{"include_enterprise_slug":false}'
else
  echo "You must pass either 'true' or 'false' as an argument to this script."
fi