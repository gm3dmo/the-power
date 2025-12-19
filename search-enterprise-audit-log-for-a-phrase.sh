.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/using-the-audit-log-api-for-your-enterprise
# 


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    phrase="action:repo.create"
  else
    phrase=$1
fi


curl -i  ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/audit-log?phrase=${phrase}"  

