.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#list-deployments
# GET /repos/{owner}/{repo}/deployments

if [ -z "$1" ]
  then
    repo=${repo}
  else
    repo=$1
fi

curl  ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/deployments
