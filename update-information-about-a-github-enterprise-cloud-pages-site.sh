.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pages/pages?apiVersion=2022-11-28#update-information-about-a-github-enterprise-cloud-pages-site
# PUT /repos/{owner}/{repo}/pages


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


public="false"

json_file=tmp/skeleton.json
jq -n \
           --arg public "${public}" \
           '{
             public : $public | test("true")
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PUT \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/pages"  --data @${json_file}
