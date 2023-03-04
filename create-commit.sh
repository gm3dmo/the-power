. .gh-api-examples.conf

# Not tested. Doesn't work yet.
# POST /repos/:owner/:repo/git/commits

json_file=tmp/create-commit.json
rm -f ${json_file}

jq -n \
                --arg name     "${default_committer}" \
                --arg message  "test commit message ${RANDOM}" \
                --arg email    "${USER}+${default_committer}@${mail_domain}" \
                --arg date     "$(date +%Y-%m-%dT%H:%M:%S)" \
                --arg tree_sha "7dd28cd40fec7cb1981fc6558a059092afdb23ec" \
                '{message: $message, "author":{ "name" : $name, "email": $email , "date": $date}, "parents": [], "tree": $tree_sha   }'  > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/commits --data @${json}

rm -f ${json}
