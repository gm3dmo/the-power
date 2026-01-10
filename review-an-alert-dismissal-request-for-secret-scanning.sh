.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/secret-scanning/alert-dismissal-requests?apiVersion=2022-11-28#review-an-alert-dismissal-request-for-secret-scanning
# PATCH /repos/{owner}/{repo}/dismissal-requests/secret-scanning/{alert_number}

if [ -z "$1" ]
  then
    alert_number=1
  else
    alert_number=$1
fi

status="approve"
message="pwr review alert dismissal status: $status"

json_file=tmp/review-an-alert-dismissal-request-for-secret-scanning.json
jq -n \
     --arg status "${status}" \
     --arg message "${message}" \
           '{
             status: $status,
             message: $message
            }' > ${json_file}


GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')
set -x
curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/dismissal-requests/secret-scanning/${alert_number}" --data @${json_file}

