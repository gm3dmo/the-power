. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

raw_text="/docs/README.md @${org}/${team_slug}\n/.gitattributes @${default_committer}"
base64_string=$(echo ${raw_text} | /usr/bin/base64)
content=${base64_string}
filename_in_repo=CODEOWNERS

json_file=tmp/create-commit-codeowners.json

jq -n \
                --arg nm "${default_committer}" \
                --arg ms  "Create a CODEOWNERS file" \
                --arg em  "${USER}+${default_committer}@${mail_domain}" \
                --arg ct  "${content}" \
                '{message: $ms, "committer":{ "name" : $nm, "email": $em }, content: $ct }'  > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename_in_repo} --data @${json_file}
