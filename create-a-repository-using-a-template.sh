.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#create-a-repository-using-a-template
# POST /repos/{template_owner}/{template_repo}/generate

template_repo="template-repo"
template_owner=${org}
ts=$(date +%s)
new_repo="from-template-repo-${ts}"

json_file=tmp/create-a-repository-using-a-template.json

jq -n \
           --arg repo_name "${new_repo}" \
           --arg template_owner "${template_owner}" \
           '{
             "name" : $repo_name,
             "owner" : $template_owner,
             "include_all_branches": false,
             "private": true
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${template_owner}/${template_repo}/generate  --data @${json_file}

