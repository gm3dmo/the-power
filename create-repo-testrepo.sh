.  ./.gh-api-examples.conf

#
#

p=true
json_file=tmp/repo-config.json
rm -f ${json_file}

jq -n \
        --arg name "${repo}" \
        --arg pr $p \
        --arg has_issues ${has_issues} \
        --arg has_projects ${has_projects}  \
        --arg has_wiki ${has_wiki}  \
        --arg has_discussions ${has_discussions} \
        --arg has_pages ${has_pages} \
        --arg description "This is: ${repo}, it's a private repo. You can look at the hooks: ${webhook_url} if that helps." \
        --arg allow_auto_merge "${allow_auto_merge}" \
	'{ name : $name, 
	   description: $description, 
	   private: $pr | test("true"), 
	   allow_auto_merge: $allow_auto_merge | test("true"), 
	   has_issues: $has_issues | test("true"), 
	   has_projects: $has_projects | test("true"), 
	   has_wiki: $has_wiki | test("true"), 
	   has_discussions: $has_discussions | test("true"), 
	   has_pages: $has_pages | test("true") 
         }' > ${json_file}

cat $json_file | jq -r


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/orgs/${org}/repos --data @${json_file}




