.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.1/rest/reference/enterprise-admin#create-a-pre-receive-hook
# POST /admin/pre-receive-hooks

json_file=tmp/pre-receive-hook-details.json

jq -n \
           --arg name "${pre_receive_hook_name}" \
           --arg script ${pre_receive_hook_script} \
           --arg script_repository ${org}/${pre_receive_hook_repo} \
           --arg environment ${pre_receive_environment_id} \
           --arg enforcement ${pre_hook_enforcement} \
           --arg allow_downstream_configuration ${pre_hook_allow_downstream} \
           --arg visibility ${default_repo_visibility} \
             '{
                name: $name,
                script: $script,
                script_repository: { "full_name": $script_repository },
                environment: { "id": $environment | tonumber } ,
                enforcement: $enforcement,
                allow_downstream_configuration: $allow_downstream_configuration | test("true")
             }' > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.eye-scream-preview" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/admin/pre-receive-hooks --data @${json_file}
