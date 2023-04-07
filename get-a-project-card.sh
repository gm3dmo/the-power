.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/projects/cards#get-a-project-card
# GET /projects/columns/cards/{card_id}


card_id=$1


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/projects/columns/cards/${card_id}
