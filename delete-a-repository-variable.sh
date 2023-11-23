.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/variables?apiVersion=2022-11-28#delete-a-repository-variable
# DELETE /repos/{owner}/{repo}/actions/variables/{name}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

name="USERNAME"
value="octocat"

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/actions/variables/${name}"
