.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#delete-a-github-pages-site
# DELETE /repos/:owner/:repo/pages

curl ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.switcheroo-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/pages
