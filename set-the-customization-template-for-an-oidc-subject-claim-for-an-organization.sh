.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/oidc#set-the-customization-template-for-an-oidc-subject-claim-for-an-organization
# PUT /orgs/{org}/actions/oidc/customization/sub

# You must authenticate using an access token with the write:org scope to use this endpoint.

if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi

# Pass claim keys as arguments starting from $2, e.g.: ./script.sh my-org repo context job_workflow_ref
# Defaults to "repo" and "context" if no claim keys are provided.
shift 2>/dev/null

if [ $# -eq 0 ]; then
  include_claim_keys='["repo","context"]'
else
  include_claim_keys=$(printf '%s\n' "$@" | jq -R . | jq -s .)
fi

json_file=tmp/set-the-customization-template-for-an-oidc-subject-claim-for-an-organization.json
jq -n \
       --argjson include_claim_keys "${include_claim_keys}" \
           '{
             include_claim_keys: $include_claim_keys
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/actions/oidc/customization/sub" -d @${json_file}
