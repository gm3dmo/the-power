.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.1/rest/reference/repos#get-the-combined-status-for-a-specific-reference
# GET /repos/{owner}/{repo}/commits/{ref}/status

per_page=50

if [ -z "$1" ]
  then
    target_branch=${branch_name}
    sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${target_branch}| jq -r '.object.sha')
    ref=${sha}
  else
    ref=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits/${ref}/status?per_page=${per_page}
