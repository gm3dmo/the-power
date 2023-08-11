.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/variables?apiVersion=2022-11-28#create-a-repository-variable
# PATCH /repos/{owner}/{repo}/actions/variables/{name}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

json_file=tmp/create-repository-variable.json

name="USERNAME"
value="octocat2"

jq -n \
           --arg name "$name" \
           --arg value "value" \
           '{
             name : $name,
             value : $value
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/actions/variables/${name}"  --data @${json_file}
