.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#update-branch-protection
# PUT /repos/{owner}/{repo}/branches/{branch}/protection


# If the script is passed an argument $1 use that as the name of the repo
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

json_file=tmp/branch-protection.json
source_json=test-data/api-doc-set-branch-protection.json

#cat ${source_json} | jq -r  >&2

cat ${source_json}| jq --arg team_slug "$team_slug" \
                            --arg team_admin "$team_admin" \
                            --argjson enforce_admins $enforce_admins \
                            --argjson required_approving_reviewers ${required_approving_reviewers} \
    '.restrictions.users = [ $team_admin] | .restrictions.teams = [$team_slug]
     | .required_pull_request_reviews.dismissal_restrictions.users = [ $team_admin ]
     | .required_pull_request_reviews.dismissal_restrictions.teams = [ $team_slug ]
     | .required_pull_request_reviews.required_approving_review_count = $required_approving_reviewers
     | .enforce_admins = $enforce_admins
    ' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.luke-cage-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${protected_branch_name}/protection --data @${json_file}

