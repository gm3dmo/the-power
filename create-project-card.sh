.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/projects#create-a-project-card
# POST /projects/columns/:column_id/cards

column_id=$(./list-project-columns.sh | jq '[.[].id] | max')
#column_id=1
json=project-card-note.json

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.inertia-preview+json"  \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/projects/columns/${column_id}/cards --data @${json}
