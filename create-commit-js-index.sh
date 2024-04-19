.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

# https://docs.github.com/en/enterprise-cloud@latest/packages/quickstart

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

filename_in_repo="index.js"
comment="Adding ${filename_in_repo}"
json_file="tmp/create-commit.json"

content_plain_text=$(echo 'alert("Hello, World!");' > tmp/${filename_in_repo}_)
content_base64=$(./base64encode.py tmp/${filename_in_repo}_)

jq -n \
                --arg name "${default_committer}" \
                --arg ms  "${comment}" \
                --arg email  "${USER}+${default_committer}@${mail_domain}" \
                --arg content  "${content_base64}" \
                '{message: $ms, "committer":{ "name" : $name, "email": $email }, content: $content }'  > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename_in_repo} --data @${json_file}
