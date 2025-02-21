.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/audit-log?apiVersion=2022-11-28#delete-an-audit-log-streaming-configuration-for-an-enterprise
# DELETE /enterprises/{enterprise}/audit-log/streams/{stream_id}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    stream_id=$(./list-audit-log-stream-configurations-for-an-enterprise.sh | jq '[.[].id] | max')
  else
    stream_id=$1
fi


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprises/{enterprise}/audit-log/streams/${stream_id}"

