.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/branches/branches?apiVersion=2022-11-28#merge-a-branch
# POST /repos/{owner}/{repo}/merges

if [ -z "$1" ]
  then
    base=${base_branch}
  else
    base=$1
fi

if [ -z "$2" ]
  then
    head="${branch_name}"
  else
    head=$2
fi

curl ${curl_custom_flags} \
     -X POST \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/merges" \
        -d "{\"base\":\"${base}\",\"head\":\"${head}\"}"
