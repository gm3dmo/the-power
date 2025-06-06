.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/projects/projects?apiVersion=2022-11-28#list-organization-projects
# GET /orgs/{org}/projects

A=$1
wanted="preview"


if [ ${wanted} == "preview" ]; then
    >&2 echo header in place this will succeed. 
    curl ${curl_custom_flags} \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            "${GITHUB_API_BASE_URL}/orgs/${org}/projects"
else
    >&2 echo no header in place this will fail. run with 'preview' argument.
    curl ${curl_custom_flags} \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            "${GITHUB_API_BASE_URL}/orgs/${org}/projects"
fi
