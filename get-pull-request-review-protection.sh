.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#get-pull-request-review-protection
# GET /repos/{owner}/{repo}/branches/{branch}/protection/required_pull_request_reviews

branch=${protected_branch_name}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}/protection/required_pull_request_reviews"
