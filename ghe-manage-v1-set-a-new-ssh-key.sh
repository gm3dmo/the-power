.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/manage-ghes?apiVersion=2022-11-28#set-a-new-ssh-key
# POST /manage/v1/access/ssh


ts=$(date +%s)
ssh_key_file=tmp/ed25519_${ts}
ssh_public_key_file=tmp/ed25519_${ts}.pub
rm -f ${ssh_key_file} ${ssh_public_key_file}

ssh-keygen -t ed25519 -f ${ssh_key_file} -q -N '' -C "github-pwr-admin-${ts}"
ssh-keygen -l -v -f ${ssh_public_key_file}
public_key=$(cat ${ssh_public_key_file})


json_file=tmp/create-a-deploy-key.json
jq -n \
              --arg key "${public_key}" \
                    '{key: $key}' > ${json_file}


curl -v -L \
     -H "Accept: application/vnd.github.v3+json" \
     -u "api_key:${mgmt_password}" \
     -H "Content-Type: application/json" \
        "${hostname}/manage/v1/access/ssh" --data @${json_file}

