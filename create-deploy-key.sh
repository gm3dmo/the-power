. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-a-deploy-key
# POST /repos/{owner}/{repo}/keys

public_key_file=${1:-${my_ssh_pub_key}}
public_key=$(cat ${public_key_file})
ts=$(date +%s)

json=tmp/keyDetails
rm -f ${json}

DATA=$(jq -n \
              --arg title "The Key ${ts}" \
              --arg key "${public_key}" \
                    '{title: $title, key: $key}' ) 

echo ${DATA} > ${json}

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/keys --data @${json}

rm -f ${json}
