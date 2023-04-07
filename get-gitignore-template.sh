.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/gitignore#get-a-gitignore-template
# GET /gitignore/templates/{name}

name=${1:-Python}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.VERSION.raw" \
         ${GITHUB_API_BASE_URL}/gitignore/templates/${name}
