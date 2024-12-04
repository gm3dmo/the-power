.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#list-app-installations-for-an-organization
# GET /orgs/{org}/installations


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/installations" > tmp/list-app-installations-for-an-organization.json

jq -r '(["counter","id","app_id","app_slug", "repository_selection", "created_at","updated_at", "suspended_by_login","suspended_at", "html_url" ] | @csv), 
(.installations | to_entries[] | 
    [(.key + 1 | tostring), (.value.id | tostring), (.value.app_id | tostring), .value.app_slug, .value.repository_selection, .value.created_at, .value.updated_at, 

