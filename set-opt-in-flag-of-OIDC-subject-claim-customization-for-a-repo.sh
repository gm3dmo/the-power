.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/oidc#set-the-opt-in-flag-of-an-oidc-subject-claim-customization-for-a-repository
# PUT /repos/{owner}/{repo}/actions/oidc/customization/sub
# You must authenticate using an access token with the repo scope to use this endpoint.

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

use_default=$2

if [ "$use_default" != "true" ] && [ "$use_default" != "false" ]; then
  echo "You must pass either 'true' or 'false' as an argument to this script."
  exit 1
fi

json_file=tmp/set-opt-in-flag-of-an-oidc-subject-claim.json
rm -f ${json_file}

jq -n \
  --argjson use_default true '{"use_default": $use_default}' > ${json_file}

set -x
curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/oidc/customization/sub -d @${json_file}
