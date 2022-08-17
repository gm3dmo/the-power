. .gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@2.20/rest/reference/licenses#get-the-license-for-a-repository
# GET /repos/{owner}/{repo}/license

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

set -x

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/license
