.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/credentials/revoke?apiVersion=2022-11-28#revoke-a-list-of-credentials
# POST /credentials/revoke

# Put each credential in a new line in the file test-data/credentials.txt
# Example:
#   ghp_1234567890abcdef1234567890abcdef12345678
#   ghp_1234567890abcdef1234567890abcdef12345679

if [ -z "$1" ]; then
  if [ ! -f test-data/credentials.txt ]; then
    echo "Warning: test-data/credentials.txt not found. Exiting."
    exit 1
  fi
  credentials=$(jq -R -s 'split("\n") | map(select(length>0))' test-data/credentials.txt)
elif [ -f "$1" ]; then
  credentials=$(jq -R -s 'split("\n") | map(select(length>0))' "$1")
else
  credentials=$(jq -n --arg cred "$1" '[ $cred ]')
fi

json_file=tmp/revoke-a-list-of-credentials.json
jq -n --argjson creds "$credentials" '{ credentials: $creds }' > "$json_file"

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     "${GITHUB_API_BASE_URL}/credentials/revoke" --data @"$json_file"

