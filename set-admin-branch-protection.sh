.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection?apiVersion=2022-11-28#set-admin-branch-protection
# POST /repos/{owner}/{repo}/branches/{branch}/protection/enforce_admins

branch=${protected_branch_name}

curl ${curl_custom_flags} \
     -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}/protection/enforce_admins"
