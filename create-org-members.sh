.  ./.gh-api-examples.conf

# Create org members. These are not members of a team.
# Useful to test privileges.

org=${1:-$org}

people_file=tmp/longlistofpeople.txt
head -${number_of_users_to_create_on_ghes} test-data/NAMES.TXT > ${people_file}
nl $people_file

for person in $(cat ${people_file})
do
    curl ${curl_custom_flags} \
         -X PUT \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${person}
done
