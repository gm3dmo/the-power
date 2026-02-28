.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/secret-scanning/secret-scanning?apiVersion=2022-11-28#update-a-secret-scanning-alert
# PATCH /repos/{owner}/{repo}/secret-scanning/alerts/{alert_number}

if [ -z "$1" ]
  then
    alert_number=1
  else
    alert_number=$1
fi

state="resolved"
resolution="revoked"

json_file=tmp/update-a-secret-scanning-alert.json
jq -n \
     --arg state "${state}" \
     --arg resolution "${resolution}" \
           '{
             state: $state,
             resolution: $resolution
            }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/secret-scanning/alerts/${alert_number}" --data @${json_file}
