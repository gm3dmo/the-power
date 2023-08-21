.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/checks/suites?apiVersion=2022-11-28#update-repository-preferences-for-check-suites
# PATCH /repos/{owner}/{repo}/check-suites/preferences

json_file=tmp/skeleton.json

auto_trigger_checks=false

jq -n \
           --arg auto_trigger_checks "${auto_trigger_checks}" \
           --argjson app_id "${default_app_id}" \
           '{
	   auto_trigger_checks : [ {app_id: $app_id, "setting": $auto_trigger_checks | test("true")}] 
           }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/check-suites/preferences  --data @${json_file}

