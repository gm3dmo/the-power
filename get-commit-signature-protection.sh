.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-commit-signature-protection
# GET /repos/{owner}/{repo}/branches/{branch}/protection/required_signatures

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Accept: application/vnd.github.zzzax-preview+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${protected_branch_name}/protection/required_signatures
