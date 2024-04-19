.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

raw_text="this is a test for the draft pull request on ${protected_branch_name}"
base64_string=$(echo ${raw_text} | ./base64encode.py)
content=${base64_string}
branch=foo_branch

json_file=tmp/testfile.json

jq -n \
                --arg nm "Rosie the Committer." \
                --arg ms  "test commit message" \
                --arg em  "${USER}+${default_committer}@${mail_domain}" \
                --arg br  "foo_branch" \
                --arg ct  "${content}" \
                '{message: $ms, "committer":{ "name" : $nm, "email": $em }, branch: $br, content: $ct }'  > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/test.txt --data @${json_file}
