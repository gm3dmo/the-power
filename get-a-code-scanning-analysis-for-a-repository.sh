.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-scanning#get-a-code-scanning-analysis-for-a-repository
# GET /repos/{owner}/{repo}/code-scanning/analyses/{analysis_id}

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
   analysis_id=$(./list-code-scanning-analyses-for-a-repository.sh | jq '[.[].id] | max') 
  else
    analysis_id=$1
fi

set -x
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/code-scanning/analyses/${analysis_id}
