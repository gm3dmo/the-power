.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/manage-ghes?apiVersion=2022-11-28#set-a-new-ssh-key
# POST /manage/v1/access/ssh

# Note that the Content-Type: application/json is needed in 3.14, 3.14 as at January 2025. This may not be documented above.


ts=$(date +%s)
ssh_key_file=tmp/key_${ts}
ssh_public_key_file=tmp/key_${ts}.pub
rm -f ${ssh_key_file} ${ssh_public_key_file}
key_type=rsa

ssh-keygen -t ${key_type}  -f ${ssh_key_file} -q -N '' -C "pwr-admin-ssh-${ts}"
ssh-keygen -l -v -f ${ssh_public_key_file}
public_key=$(cat ${ssh_public_key_file})


json_file=tmp/set-a-new-ssh-key.json
jq -n \
              --arg key "${public_key}" \
                    '{key: $key}' > ${json_file}


curl -L \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
     -u "api_key:${mgmt_password}" \
        "https://${hostname}:${mgmt_port}/manage/v1/access/ssh" --data @${json_file}
        
