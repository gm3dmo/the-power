. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

raw_text="*.dos text eol=crlf\n.gitignore export-ignore" 
base64_string=$(echo ${raw_text} | base64)
content=${base64_string}

json_file=tmp/create-commit-gitattributes.json

jq -n \
                --arg nm "${default_committer}" \
                --arg ms  "test commit message" \
                --arg em  "${USER}+${default_committer}@${mail_domain}" \
                --arg ct  "${content}" \
                '{message: $ms, "committer":{ "name" : $nm, "email": $em }, content: $ct }'  > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/.gitattributes --data @${json_file}
