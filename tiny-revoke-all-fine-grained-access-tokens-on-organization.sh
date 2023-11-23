.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/personal-access-tokens?apiVersion=2022-11-28#update-the-access-to-organization-resources-via-fine-grained-personal-access-tokens
# POST /orgs/{org}/personal-access-tokens

# This can be used to revoke all the fine grained pats with access to an organization


# Get a list of fine grained pat id's to revoke:
pat_ids=$(./tiny-list-fine-grained-personal-access-tokens-with-access-to-organization-resources.sh | jq -r '[.[] | .id] |  join(",")')

action="revoke"

json_file=tmp/tiny-revoke-all-fine-grained-access-tokens-on-organization.json

jq -n \
           --arg action "${action}" \
           --arg pat_ids "${pat_ids}" \
           '{
             action: $action,
             pat_ids:  $pat_ids | split(",") | map(tonumber)
           }' > ${json_file}


cat $json_file | jq -r 


GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

# Revoke
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/personal-access-tokens"  --data @${json_file}
