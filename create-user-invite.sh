.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#add-a-repository-collaborator
# PUT /repos/:owner/:repo/collaborators/:username



# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    outside_collaborator=${default_invitee}
  else
    outside_collaborator=$1
fi


curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/collaborators/${outside_collaborator}
