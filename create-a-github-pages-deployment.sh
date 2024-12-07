.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/pages/pages?apiVersion=2022-11-28#create-a-github-pages-deployment
# POST /repos/{owner}/{repo}/pages/deployments


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

echo "oidc_token string Required The OIDC token issued by GitHub Actions certifying the origin of the deployment."
echo "i haven't had time to look at how to get this OIDC token"
echo "this script will exit now"
exit 1

json_file=tmp/create-a-github-pages-deployment.json
jq -n \
           --arg name "${repo}" \
           '{
             name : $name,
           }' > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/pages/deployments"  --data @${json_file}

