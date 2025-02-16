.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/activity#list-stargazers
# GET /repos/{owner}/{repo}/stargazers


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
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/stargazers"

