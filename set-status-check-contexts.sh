.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#set-status-check-contexts
# PUT /repos/{owner}/{repo}/branches/{branch}/protection/required_status_checks/contexts

branch=${protected_branch_name}

json_file=tmp/set-status-check-contexts.json
jq -n \
       --arg required_status_check_name "${required_status_check_name}" \
       '{
         contexts: [ $required_status_check_name ]
       }' > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}/protection/required_status_checks/contexts" --data @${json_file}
