. .gh-api-examples.conf

#
#

p=true
json_file=tmp/repoDetails
rm -f ${json_file}

DATA=$(jq -n \
                  --arg name "${repo}" \
                  --arg pr $p \
                  --arg has_issues true \
                  --arg has_projects true \
                  --arg has_wiki true \
                  --arg description "This is: ${repo}, it's a private repo.  You can look at the hooks: ${webhook_url} if that helps." \
                  --arg allow_auto_merge "${allow_auto_merge}" \
                  '{name : $name, description: $description, private: $pr | test("true"), allow_auto_merge: $allow_auto_merge, has_issues: $has_issues, has_projects: $has_projects, has_wiki: $has_wiki }' )

echo ${DATA} > ${json_file}

cat $json_file | jq -r


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/repos --data @${json_file}
