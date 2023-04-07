.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/forks?apiVersion=2022-11-28#create-a-fork
# POST /repos/{owner}/{repo}/forks


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


json_file=tmp/create-a-fork.json

timestamp=$(date +%s)


jq -n \
           --arg name "${repo}-fork-${timestamp}" \
           --arg organization "${org}" \
           --arg default_branch_only "true" \
           '{
             name : $name,
             organization: $organization,
             default_branch_only: $default_branch_only | test("true")
           }' > ${json_file}


cat $json_file | jq -r


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/forks  --data @${json_file}

