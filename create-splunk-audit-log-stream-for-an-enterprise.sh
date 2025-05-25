.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/enterprise-admin/audit-log?apiVersion=2022-11-28#create-an-audit-log-streaming-configuration-for-an-enterprise
# POST /enterprises/{enterprise}/audit-log/streams


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    stream_no=2
  else
    stream_no=$1
fi

# Configuration comes from the .gh-api-examples.conf file section "Splunk Audit Log Stream"

# Key ID obtained from the audit log stream key endpoint used to encrypt secrets.
audit_key_details="tmp/audit-log-stream-key.json"
./get-the-audit-log-stream-key-for-encrypting-secrets.sh > ${audit_key_details}
key_id=$(jq -r '.key_id' ${audit_key_details})
key=$(jq -r '.key' ${audit_key_details})
encrypted_token=$(ruby create-enterprise-audit-log-stream-key.rb $key $token)


json_file=tmp/create-an-audit-log-streaming-configuration-for-an-enterprise.json
jq -n \
           --arg stream_type "$stream_type" \
           --arg domain "$domain" \
           --arg port "$port" \
           --arg key_id "$key_id" \
           --arg encrypted_token "$encrypted_token" \
           --arg ssl_verify "$ssl_verify" \
           --arg enabled "$enabled" \
           '{
             stream_type : $stream_type,
             enabled : $enabled | test("true"),
             vendor_specific :  {
               domain : $domain,
               port : $port | tonumber,
               key_id : $key_id,
               encrypted_token : $encrypted_token,
               ssl_verify: $ssl_verify | test("true")
             }
           }' > ${json_file}

curl -L \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "X-GitHub-Api-Version: $github_api_version" \
        "$GITHUB_API_BASE_URL/enterprises/${enterprise}/audit-log/streams" --data @${json_file}

