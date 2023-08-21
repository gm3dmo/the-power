.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-scanning#get-a-codeql-database-for-a-repository
# GET /repos/{owner}/{repo}/code-scanning/codeql/databases/{language}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    language=javascript
  else
    language=$1
fi


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/code-scanning/codeql/databases/${language}
