.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/branches/branch-protection?apiVersion=2022-11-28
# GET /repos/{owner}/{repo}/branches/{branch}/protection

# If the script is passed an argument $1 use that as the name of the repo
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

json_file=tmp/branch-protection.json

source_json=test-data/api-doc-set-branch-protection.json

cat ${source_json}| jq --arg team_slug "$team_slug" \
                            --arg team_admin "$team_admin" \
                            --argjson enforce_admins $enforce_admins \
                            --argjson required_approving_reviewers ${required_approving_reviewers} \
                            --arg required_status_check_name ${required_status_check_name} \
    '.restrictions.users = [ $team_admin] | .restrictions.teams = [$team_slug]
     | .required_status_checks.checks = [ { context: $required_status_check_name, app_id: null  },{ context: "ci/commit-status-optional", app_id: null  } ]
     | .required_pull_request_reviews.dismissal_restrictions.users = [ $team_admin ]
     | .required_pull_request_reviews.dismissal_restrictions.teams = [ $team_slug ]
     | .required_pull_request_reviews.required_approving_review_count = $required_approving_reviewers
     | .enforce_admins = $enforce_admins
    ' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${protected_branch_name}/protection" --data @${json_file}

