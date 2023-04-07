.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-an-organization-repository
# POST /orgs/{org}/repos

json_file=tmp/repo-details.json
rm -f ${json_file}

DATA=$(jq -n \
              --arg nm "${repo}-archived" \
              --arg pr "private" \
              --arg archived "true" \
                    '{name : $nm, private: $pr | test("true"),  archived: $archived |test("true") }' ) 

echo ${DATA} > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/repos --data @${json_file}

rm -f ${json_file}
