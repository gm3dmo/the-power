.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-a-commit
# GET /repos/:owner/:repo/commits/:ref

repo=${1}
ref=${2}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits/${ref}
