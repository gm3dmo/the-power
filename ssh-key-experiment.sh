.  ./.gh-api-examples.conf
# This script might damage an existing ssh config file
# and you should probably not use it
exit

# https://docs.github.com/en/enterprise-cloud@latest/rest/deploy-keys/deploy-keys?apiVersion=2022-11-28#create-a-deploy-key
# POST /repos/{owner}/{repo}/keys
# As per the documentation the app will need at least "Administration" permission on the repository.

set -x
ts=$(date +%s)

ssh_key_file=~/.ssh/ed25519
ssh_public_key_file=~/.ssh/ed25519.pub
rm -f ${ssh_key_file} ${ssh_public_key_file}
echo $?

ssh-keygen -t ed25519 -f ${ssh_key_file} -q -N '' -C "crispy-key-${ts}"
echo $?

ssh-keygen -l -v -f ${ssh_public_key_file}
echo $?

public_key=$(cat ${ssh_public_key_file})

json_file=tmp/create-a-deploy-key.json

jq -n \
              --arg title "Crispy Key ${ts}" \
              --arg key "${public_key}" \
                    '{title: $title, key: $key}' > ${json_file}

cat $json_file | jq -r


# Set this if you are using an oauth token
#GITHUB_TOKEN=
echo "Sending with token: ${GITHUB_TOKEN}"

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        "${GITHUB_API_BASE_URL}/user/keys" --data @${json_file}

echo $?

ssh_cf=~/.ssh/config
rm -f ${ssh_cf}

echo ==============
echo $ssh_key_file
echo $ssh_public_key_file
echo ==============
echo " Creating ssh config file"
echo host github.com > ${ssh_cf}
echo     HostName github.com >> ${ssh_cf}
echo     IdentityFile ${ssh_key_file} >> ${ssh_cf}
echo
echo
ssh -T git@github.com
echo
echo
rm -rf $repo
echo "cloning"
git clone git@github.com:${org}/${repo}.git
