. .gh-api-examples.conf

#
#

echo $repo
p=true
json_file=tmp/repoDetails
rm -f ${json_file}

DATA=$(jq -n \
                  --arg nm "${repo}" \
                  --arg pr $p \
                  --arg hi true \
                  --arg hasp true \
                  --arg description "This is: ${repo}, it's a private repo.  You can look at the hooks: ${webhook_url} if that helps." \
                  --arg hw true \
                  '{name : $nm, description: $description, private: $pr | test("true"), has_issues: $hi, has_projects: $hasp, has_wiki: $hw }' )

echo ${DATA} > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/repos --data @${json_file}
