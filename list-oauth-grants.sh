.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/oauth-authorizations/oauth-authorizations?apiVersion=2022-11-28#list-your-grants
# GET /applications/grants
# Under deprecation notice


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -u ${default_user} "${GITHUB_API_BASE_URL}/applications/grants"

