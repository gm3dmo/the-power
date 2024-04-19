.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

raw_text="/README.md @${org}/${team_slug}" 
base64_string=$(cat test-data/lorem.txt  | ./base64encode.py)
content=${base64_string}

json_file=tmp/create-commit-lorem.json

path="riscprocessservApi/src/main/java/com/test/erc/riscprocessserv/utils/RiskConstants.java"
chrlen=${#path}
commit_message="test commit with ${chrlen} characters"

jq -n \
                --arg name     $default_committer \
                --arg message  "${commit_message}" \
                --arg email    "${USER}+${default_committer}@${mail_domain}" \
                --arg content  "${content}" \
                '{message: $message, "committer":{ "name" : $name, "email": $email }, content: $content }'  > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${path} --data @${json_file}
