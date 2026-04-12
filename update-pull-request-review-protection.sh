.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#update-pull-request-review-protection
# PATCH /repos/{owner}/{repo}/branches/{branch}/protection/required_pull_request_reviews

branch=${protected_branch_name}

json_file=tmp/update-pull-request-review-protection.json
jq -n \
       --argjson required_approving_reviewers ${required_approving_reviewers} \
       '{
         required_approving_review_count: $required_approving_reviewers
       }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}/protection/required_pull_request_reviews" --data @${json_file}
