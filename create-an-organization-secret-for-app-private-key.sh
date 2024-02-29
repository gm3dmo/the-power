.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#create-or-update-an-organization-secret
# PUT /orgs/{org}/actions/secrets/{secret_name}

json_file=tmp/organization-secret.json
rm -f ${json_file}

secret_name=${app_cert_secret_name}
visibility="all"
key_id=$(./get-an-organization-public-key.sh | jq -r '.key_id')
org_public_key=$(./get-an-organization-public-key.sh | jq -r '.key')
export private_pem_file
echo $private_pem_file
encrypted_value=$(ruby create-an-organization-secret-for-app-private-key.rb ${org_public_key})

jq -n \
           --arg secret_name "${secret_name}" \
           --arg key_id "${key_id}" \
           --arg visibility "${visibility}" \
           --arg encrypted_value "${encrypted_value}" \
           '{
             secret_name: $secret_name,
             key_id: $key_id,
             visibility: $visibility,
             encrypted_value: $encrypted_value
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/orgs/${org}/actions/secrets/${secret_name} --data @${json_file}
