.  ./.gh-api-examples.conf

# To use this invoke `list-repo-by-id.sh 3` with a repository id
repo_id=$1

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repositories/${repo_id}
