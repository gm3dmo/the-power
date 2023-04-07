.  ./.gh-api-examples.conf

# This gets any url passed to it.

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${1}
