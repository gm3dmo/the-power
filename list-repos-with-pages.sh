.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#list-organization-repositories
# GET /orgs/{org}/repos


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/repos" | jq '.[] | select( .has_pages == true ) |  { ID:.id, Name:.name, NameFull:.fullname, desc:.Description, owner:.owner.type, private:.private, pages:.has_pages } '

