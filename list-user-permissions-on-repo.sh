.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#get-repository-permissions-for-a-user
# GET /repos/:owner/:repo/collaborators/:username/permission

for team_member in ${team_members}
do
  curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/collaborators/${team_member}/permission"
done
