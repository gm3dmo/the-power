.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/api-insights?apiVersion=2022-11-28#get-route-stats-by-actor
# GET /orgs/{org}/insights/api/route-stats/{actor_type}/{actor_id}

actor_type="installations"
actor_id=${default_installation_id}

MIN_TIMESTAMP="2024-11-11"
MAX_TIMESTAMP="2024-11-12"

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/insights/api/route-stats/${actor_type}/${actor_id}?min_timestamp=${MIN_TIMESTAMP}&max_timestamp=${MAX_TIMESTAMP}"

