.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/orgs?apiVersion=2022-11-28#list-saml-sso-authorizations-for-an-organization
# GET /orgs/{org}/credential-authorizations


# If the script is passed an argument $1 use that as the org
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/credential-authorizations" | jq -r 'map({credential_id, login, credential_authorized_at, credential_accessed_at, authorized_credential_id, authorized_credential_note}) | (if .[0] then ["credential_id", "login", "credential_authorized_at", "credential_accessed_at", "authorized_credential_id", "authorized_credential_note"] else empty end), (map([.credential_id, .login, .credential_authorized_at, .credential_accessed_at, .authorized_credential_id, .authorized_credential_note | tostring]))[] | @csv'
