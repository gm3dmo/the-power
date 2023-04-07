.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/projects#list-organization-projects
# GET /orgs/:org/projects

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.inertia-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/projects
