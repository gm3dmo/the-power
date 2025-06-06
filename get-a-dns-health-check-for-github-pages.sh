.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pages/pages?apiVersion=2022-11-28#get-a-dns-health-check-for-github-pages
# GET /repos/{owner}/{repo}/pages/health


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
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/pages/health"

