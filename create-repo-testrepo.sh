.  ./.gh-api-examples.conf

#
#

case ${default_repo_visibility} in 
   internal)
       private=false
   ;;
   public)
       private=false
   ;;
   private)
       private=true
   ;;
esac

json_file=tmp/create-testrepo.json


jq -n \
        --arg name "${repo}" \
        --arg private $private \
        --arg visibility ${default_repo_visibility}  \
        --arg has_issues ${has_issues} \
        --arg has_projects ${has_projects}  \
        --arg has_wiki ${has_wiki}  \
        --arg has_discussions ${has_discussions} \
        --arg has_pages ${has_pages} \
        --arg description "This is: ${repo}, it's a ${default_repo_visibility} repo. It's webhook is: ${webhook_url}" \
        --arg allow_auto_merge "${allow_auto_merge}" \
	'{ name : $name, 
	   description: $description, 
	   private: $private | test("true"), 
	   visibility: $visibility, 
	   allow_auto_merge: $allow_auto_merge | test("true"), 
	   has_issues: $has_issues | test("true"), 
	   has_projects: $has_projects | test("true"), 
	   has_wiki: $has_wiki | test("true"), 
	   has_discussions: $has_discussions | test("true"), 
	   has_pages: $has_pages | test("true") 
         }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/repos" --data @${json_file}
