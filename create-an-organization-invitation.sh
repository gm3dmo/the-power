.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/orgs#create-an-organization-invitation
# POST /orgs/{org}/invitations

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    email_of_invitee=${email_of_invitee}
  else
    email_of_invitee=$1
fi

role="direct_member"

json_file=tmp/create-an-organization-invitation-json.sh

jq -n \
           --arg email_of_invitee "${email_of_invitee}" \
           --arg role "${role}" \
           --arg org "${org}" \
           '{
             email: $email_of_invitee,
             org: $org,
             role: $role
           }' > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/invitations --data @${json_file}
