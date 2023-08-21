.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/custom-roles?apiVersion=2022-11-28#create-a-custom-repository-role
# POST /orgs/{org}/custom-repository-roles



json_file=tmp/create-a-custom-repository-role.json


name="testtuesday"
description="A role for issue and pull request labelers test"
base_role="read"

jq -n \
           --arg name "${name}" \
           --arg description "${description}" \
           --arg base_role "${base_role}" \
           '{
             name : $name,
             description : $description,
             base_role: $base_role,
            "permissions": [
    "add_label"
  ]
           }' > ${json_file}



set -x
curl -i ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/orgs/${org}/custom-repository-roles  --data @${json_file}
