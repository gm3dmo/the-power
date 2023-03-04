

# https://docs.github.com/en/rest/reference/repos#get-a-repository
# GET /repos/{owner}/{repo}

org=""
repo=""
GITHUB_TOKEN=""

curl \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        https://api.github.com/repos/${org}/${repo}
