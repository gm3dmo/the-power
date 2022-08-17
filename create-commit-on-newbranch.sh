. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

# If the script is passed an argument $1 use that as the name of the repo
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

raw_text="*.dos text eol=crlf" 
base64_string=$(echo ${raw_text} | base64)
content=${base64_string}

json_file=tmp/create-commit-gitattributes.json

jq -n \
                --arg nm "${default_committer}" \
                --arg ms "test commit message" \
                --arg em "${USER}+${default_committer}@${mail_domain}" \
                --arg br "${branch_name}" \
                --arg ct "${content}" \
                '{message: $ms, "committer":{ "name" : $nm, "email": $em }, branch: $br, content: $ct }'  > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/.gitattributes --data @${json_file}
