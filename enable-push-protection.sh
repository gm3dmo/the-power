.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#update-a-repository
# PATCH /repos/{owner}/{repo}

json_file=tmp/update-repo.json

secret_scanning="enabled"
advanced_security="enabled"
push_protection="enabled"


jq -n \
           --arg advanced_security ${advanced_security} \
           --arg secret_scanning ${secret_scanning} \
           --arg push_protection ${push_protection} \
           '{
              "security_and_analysis": {
                  "advanced_security": {"status": $advanced_security}, 
                  "secret_scanning":   {"status": $secret_scanning}, 
                  "secret_scanning_push_protection":   {"status": $push_protection} 
            }}
           ' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}" --data @${json_file}
