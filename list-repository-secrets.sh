.  ./.gh-api-examples.conf

# https://docs.github.com/en/free-pro-team@latest/rest/actions/secrets?apiVersion=2022-11-28#list-repository-secrets
# GET /repos/{owner}/{repo}/actions/secrets

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/secrets"
