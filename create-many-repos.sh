.  ./.gh-api-examples.conf

p=false

for reponame in $(cat tmp/long-list-of-repos.txt)
do
json_file=tmp/many-repo-details.json
rm -f ${json_file}

DATA=$(jq -n \
                  --arg nm "${reponame}" \
                  --arg hp "${repohomepage}" \
                  --arg pr $p \
                  --arg hi true \
                  --arg hasp true \
                  '{name : $nm, homepage: $hp, private: $pr | test("true")  }' )

echo ${DATA} > $json_file

curl ${curl_custom_flags} \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/repos --data @${json_file}
done
rm -f ${json_file}
