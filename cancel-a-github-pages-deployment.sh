.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pages/pages?apiVersion=2022-11-28#cancel-a-github-pages-deployment
# post /repos/{owner}/{repo}/pages/deployments/{pages_deployment_id}/cancel


pages_deployment_id=$1

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/pages/deployments/${pages_deployment_id}/cancel"

