.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/personal-access-tokens?apiVersion=2022-11-28#update-the-access-to-organization-resources-via-fine-grained-personal-access-tokens
# POST /orgs/{org}/personal-access-tokens

pat_ids=$1

action="revoke"

json_file=tmp/update-the-access-to-organization-resources-via-fine-grained-personal-access-tokens.json

jq -n \
           --arg action "${action}" \
           --arg pat_ids "${pat_ids}" \
           '{
             action: $action,
             pat_ids:  $pat_ids | split(",") | map(tonumber)
           }' > ${json_file}


GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/personal-access-tokens"  --data @${json_file}
