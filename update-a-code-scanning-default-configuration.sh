.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/code-scanning/code-scanning?apiVersion=2022-11-28#update-a-code-scanning-default-setup-configuration
# PATCH /repos/{owner}/{repo}/code-scanning/default-setup

json_file=tmp/update-a-code-scanning-default-setup-configuration.json

wanted_state="configured"
#wanted_state="not-configured"
#wanted_state=$1

query_suite="default"
languages="python"

jq -n \
           --arg state "${wanted_state}" \
           --arg query_suite "${query_suite}" \
           --arg languages "${languages}" \
           '{
             state: $state,
             query_suite : $query_suite,
             languages : [ $languages ]
           }' > ${json_file}

#cat ${json_file} | jq -r

curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/code-scanning/default-setup"  --data @${json_file}
