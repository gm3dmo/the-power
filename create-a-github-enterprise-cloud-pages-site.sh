.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pages/pages?apiVersion=2022-11-28#create-a-github-enterprise-cloud-pages-site
# POST /repos/{owner}/{repo}/pages


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


branch=${protected_branch_name}
pages_path="/docs"

json_file=tmp/create-a-github-enterprise-cloud-pages-site.json
jq -n \
           --arg branch "${branch}" \
           --arg path "${pages_path}" \
           '{
             "source":{ "branch": $branch, "path": $path }
           }' > ${json_file}


curl -L ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/pages"  --data @${json_file}
