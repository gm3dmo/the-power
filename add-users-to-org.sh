.   ./.gh-api-examples.conf

# Add the users in ${org_members} to the organization
# These users are org members and not part of the ${team}

org=${1:-$org}

for person in ${org_members}
do
  curl ${curl_custom_flags} \
       -X PUT \
       -H "Accept: application/vnd.github.v3+json" \
       -H "Authorization: Bearer ${GITHUB_TOKEN}" \
          ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${person}
done
