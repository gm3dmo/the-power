.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/projects/cards#list-project-cards
# GET /projects/columns/{column_id}/cards

column_id=1

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/projects/columns/${column_id}/cards 
