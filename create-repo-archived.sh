.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#create-an-organization-repository
# POST /orgs/{org}/repos


json_file=tmp/create-an-organization-repository
DATA=$(jq -n \
              --arg nm "${repo}-archived" \
              --arg pr "private" \
              --arg archived "true" \
                    '{name : $nm, private: $pr | test("true"),  archived: $archived |test("true") }' ) 

echo ${DATA} > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/repos" --data @${json_file}

