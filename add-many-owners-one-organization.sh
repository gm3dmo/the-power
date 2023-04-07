.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#set-organization-membership-for-a-user
# PUT /orgs/:org/memberships/:username

for user in $(cat tmp/longlistofpeople.txt)
do
   curl ${curl_custom_flags} \
       -X PUT \
       -H "Accept: application/vnd.github.v3+json" \
       -H "Authorization: Bearer ${GITHUB_TOKEN}" \
           ${GITHUB_API_BASE_URL}/orgs/${org}/memberships/${user} --data '{"role": "admin"}'
done
