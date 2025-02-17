.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/branches/branch-protection?apiVersion=2022-11-28#remove-status-check-contexts
# DELETE /repos/{owner}/{repo}/branches/{branch}/protection/required_status_checks/contexts


branch=${protected_branch_name}

json_file=tmp/remove-status-check-contexts.json
jq -n \
           --arg required_status_check_name "${required_status_check_name}" \
           '{
             contexts:  [ $required_status_check_name ]
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/branches/${branch}/protection/required_status_checks/contexts" --data @${json_file}

