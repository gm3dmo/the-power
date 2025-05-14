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


enabled=true
stream_type="Azure Blob Storage"


json_file=tmp/create-an-audit-log-streaming-configuration-for-an-enterprise.json
jq -n \
           --arg enabled "$enabled" \
           --arg stream_type "$stream_type" \
           --arg stream1_azure_blob_sas_url "$stream1_azure_blob_sas_url" \
           --arg stream1_container "$stream1_container" \
           '{
             enabled : $enabled,
             stream_type: $stream_type,
             vendor_specific: { AzureBlobConfig : {
               encrypted_sas_url: $stream1_azure_blob_sas_url,
               key_id: $key_id
             }
             }
           }' > ${json_file}

cat $json_file | jq -r

set -x
curl -v -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "X-GitHub-Api-Version: $github_api_version" \
     "$GITHUB_API_BASE_URL/enterprises/${enterprise}/audit-log/streams" --data @${json_file}
