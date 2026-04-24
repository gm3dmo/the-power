.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/oidc#set-the-customization-template-for-an-oidc-subject-claim-for-a-repository
# PUT /repos/{owner}/{repo}/actions/oidc/customization/sub

# You must authenticate using an access token with the repo scope to use this endpoint.

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

# Pass use_default as $2 (true or false), and claim keys as $3+
# Example: ./script.sh my-repo false repo context job_workflow_ref
# Example: ./script.sh my-repo true
use_default=${2:-false}

shift 2 2>/dev/null

if [ "$use_default" = "true" ]; then
  include_claim_keys='[]'
else
  if [ $# -eq 0 ]; then
    include_claim_keys='["repo","context"]'
  else
    include_claim_keys=$(printf '%s\n' "$@" | jq -R . | jq -s .)
  fi
fi

json_file=tmp/set-the-customization-template-for-an-oidc-subject-claim-for-a-repository.json
jq -n \
       --argjson use_default ${use_default} \
       --argjson include_claim_keys "${include_claim_keys}" \
           '{
             use_default: $use_default,
             include_claim_keys: $include_claim_keys
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/actions/oidc/customization/sub" -d @${json_file}
