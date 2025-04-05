.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/secrets?apiVersion=2022-11-28#create-or-update-an-organization-secret
# PUT /orgs/{org}/actions/secrets/{secret_name}

# Ensure the private_pem_file variable is exported
export private_pem_file

secret_name=${app_cert_secret_name}
visibility="all"
key_id=$(./get-an-organization-public-key.sh | jq -r '.key_id')
org_public_key=$(./get-an-organization-public-key.sh | jq -r '.key')

# Encrypt the secret and handle any errors
encrypted_value=$(ruby create-an-organization-secret-for-app-private-key.rb ${org_public_key})
exit_code=$?

case $exit_code in
    0)  # Success, continue
        ;;
    1)  echo "Error: private_pem_file environment variable is not set"
        exit 1
        ;;
    2)  echo "Error: Private key file not found"
        exit 2
        ;;
    3)  echo "Error: Organization public key not provided"
        exit 3
        ;;
    4)  echo "Error: Failed to encrypt secret"
        exit 4
        ;;
    5)  echo "Error: Invalid organization public key"
        exit 5
        ;;
    *)  echo "Error: Unknown error occurred (exit code: $exit_code)"
        exit $exit_code
        ;;
esac

json_file=tmp/create-or-update-an-organization-secret.sh
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
        "${GITHUB_API_BASE_URL}/orgs/${org}/actions/secrets/${secret_name}" --data @${json_file}

