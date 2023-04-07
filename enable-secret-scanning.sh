.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#update-a-repository
# PATCH /repos/{owner}/{repo}

json_file=tmp/update-repo.json

secret_scanning="enabled"
advanced_security="enabled"

# To disable, uncomment these two lines:
#secret_scanning="disabled"
#advanced_security="disabled"

jq -n \
           --arg secret_scanning ${secret_scanning} \
           --arg advanced_security ${advanced_security} \
           '{"security_and_analysis": {"advanced_security": {"status": $advanced_security}, "secret_scanning": {"status": $secret_scanning}}}
           ' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo} --data @${json_file}
