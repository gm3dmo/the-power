.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/copilot/copilot-usage-metrics?apiVersion=2022-11-28#get-copilot-enterprise-usage-metrics-for-a-specific-day
# GET /enterprises/{enterprise}/copilot/metrics/reports/enterprise-1-day


# If the script is passed an argument $1 use that as the day
if [ -z "$1" ]
  then
    day=$(python3 -c "from datetime import date, timedelta; print((date.today() - timedelta(days=7)).isoformat())")
  else
    day=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/copilot/metrics/reports/enterprise-1-day?day=${day}"
