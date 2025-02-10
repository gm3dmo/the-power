.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/deploy-keys/deploy-keys?apiVersion=2022-11-28#create-a-deploy-key
# POST /repos/{owner}/{repo}/keys
# As per the documentation the app will need at least "Administration" permission on the repository.

public_key_file=${1:-${my_ssh_pub_key}}
public_key=$(cat ${public_key_file})
ts=$(date +%s)

ssh_key_file=tmp/ed25519_${default_app_id}
ssh_public_key_file=tmp/ed25519_${default_app_id}.pub
rm -f ${ssh_key_file} ${ssh_public_key_file}

ssh-keygen -t ed25519 -f ${ssh_key_file} -q -N '' -C "github-app-${default_app_id}"
ssh-keygen -l -v -f ${ssh_public_key_file}

public_key=$(cat ${ssh_public_key_file})

json_file=tmp/create-a-deploy-key.json

jq -n \
              --arg title "The Power Deploy Key ${ts}" \
              --arg key "${public_key}" \
                    '{title: $title, key: $key}' > ${json_file}


GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')
curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/keys" --data @${json_file}
