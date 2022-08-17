. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#list-pull-requests-associated-with-a-commit
# GET /repos/{owner}/{repo}/commits/{commit_sha}/pulls

# gnarly hardcoded commit sha or $1
commit_sha=${1:3bb79e7ba9dc8b12a18072b8333e8238ea1b3c52}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.groot-preview+json" \
     -H "Accept: application/vnd.github.shadow-cat-preview+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/commits/${commit_sha}/pulls
