.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#update-a-repository
# PATCH /repos/{owner}/{repo}

json_file=tmp/update-repo.json

secret_scanning="enabled"
advanced_security="enabled"
secret_scanning_non_provider_patterns="enabled"
code_scanning="enabled"


# To disable, uncomment these lines:
#secret_scanning="disabled"
#advanced_security="disabled"
#secret_scanning_non_provider_patterns="disabled"
#code_scanning="disabled"

jq -n \
           --arg advanced_security ${advanced_security} \
           --arg secret_scanning ${secret_scanning} \
           --arg secret_scanning_non_provider_patterns ${secret_scanning_non_provider_patterns} \
           --arg code_scanning ${code_scanning} \
           '{"security_and_analysis": {"advanced_security": {"status": $advanced_security}, 
            "secret_scanning": {"status": $secret_scanning},
            "secret_scanning_non_provider_patterns": {"status": $secret_scanning_non_provider_patterns},
            "code_scanning_default_setup": {"status": $code_scanning}
            }}
           ' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}" --data @${json_file}
