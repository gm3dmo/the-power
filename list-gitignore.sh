.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/gitignore#get-all-gitignore-templates
# GET /gitignore/templates

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/gitignore/templates
