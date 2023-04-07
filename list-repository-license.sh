.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/licenses?apiVersion=2022-11-28#get-a-license
# GET /repos/{owner}/{repo}/license

# If the script is passed an argument $1 use that as the repo
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/license
