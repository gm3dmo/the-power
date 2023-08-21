.  ./.gh-api-examples.conf

# [!] This only works on GitHub Enterprise Cloud.
# https://docs.github.com/en/rest/scim#get-scim-provisioning-information-for-a-user
# GET /scim/v2/organizations/{org}/Users/{scim_user_id}

if [ -z "$1" ]
  then
    scim_user_id=$(./list-scim-provisioned-identities.sh | jq '.Resources[].id' | tr -d '"' | head -n 1)
  else
    scim_user_id=${1}
fi

echo ${scim_user_id}

curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/scim/v2/organizations/${org}/Users/${scim_user_id}