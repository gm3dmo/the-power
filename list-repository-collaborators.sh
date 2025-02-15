.   ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/collaborators/collaborators?apiVersion=2022-11-28
# GET /repos/{owner}/{repo}/collaborators


if [ -z "$1" ]
  then
    affiliation="outside"
    #affiliation="all"
    #affiliation="direct"
  else
   affiliation=$1
fi


set -x
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/collaborators?affiliation=${affiliation}"

