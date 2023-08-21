.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-an-environment
# PUT /repos/{owner}/{repo}/environments/{environment_name}

environment_name=${default_environment_name}
wait_timer=1


deployment_branch_policy=protected_branches
reviewer_id=$(./list-user.sh ${default_committer} | jq -r '.id')

json_file=tmp/create-an-environment.json

jq -n \
           --argjson  reviewer_id "${reviewer_id}" \
           --argjson  wait_timer "${wait_timer}" \
           --arg protected_branches false \
           --arg custom_branch_policies true \
           '{
             "wait_timer" : $wait_timer,
             "reviewers": [ {"type": "User", "id": $reviewer_id}],
             "deployment_branch_policy":  {"protected_branches": $protected_branches | test("true") , "custom_branch_policies": $custom_branch_policies | test("true") }
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/environments/${environment_name} --data @$json_file
