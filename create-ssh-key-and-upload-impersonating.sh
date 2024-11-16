.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/users#create-a-public-ssh-key-for-the-authenticated-user
# POST /user/keys

user_to_impersonate=${1:-$default_committer}

IMPERSONATION_TOKEN=$(bash create-impersonation-oauth-token.sh ${user_to_impersonate}| jq -r '.token')
GITHUB_TOKEN=${IMPERSONATION_TOKEN}

json_file="tmp/create-ssh-key-and-upload-impersonating.json"

ssh_key_file=tmp/ed25519_${team_member}
ssh_public_key_file=tmp/ed25519_${team_member}.pub

rm -f ${ssh_key_file} ${ssh_public_key_file}

ssh-keygen -t ed25519 -f ${ssh_key_file} -q -N '""' -C "${user_to_impersonate}@example.com"


public_key_file=${ssh_key_file}
public_key=$(cat ${ssh_public_key_file})

json_file=tmp/ssh-key-${user_to_impersonate}.json

ts=$(date +%s)

DATA=$(jq -n \
                --arg title "The Power ssh key uploaded for ${user_to_impersonate} at timestamp: ${ts}" \
                --arg key "${public_key}" \
                '{title: $title, key: $key}' )
echo $DATA > ${json_file}


curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        "${GITHUB_API_BASE_URL}/user/keys" --data @${json_file}

