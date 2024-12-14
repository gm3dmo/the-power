.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/checks/suites?apiVersion=2022-11-28#list-check-suites-for-a-git-reference
# GET /repos/{owner}/{repo}/commits/{ref}/check-suites


if [ -z "$1" ]
  then
     ref=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${branch_name}| jq -r '.object.sha')
  else
     ref=$1
fi


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits/${ref}/check-suites" 

