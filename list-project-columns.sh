.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/projects/columns?apiVersion=2022-11-28#list-project-columns
# GET /projects/{project_id}/columns


project_id=$(./list-projects.sh preview | jq '.[] | .id')

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/projects/${project_id}/columns"

