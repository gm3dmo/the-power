. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-reference
# POST /repos/:owner/:repo/git/refs

# If the script is passed an argument $1 use that as the name of the repo
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

timestamp=$(date +"%s")
json_file=tmp/create-branch-protectedbranch.json


sha=$(curl ${curl_custom_flags} --silent -H "Authorization: token ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${base_branch} | jq -r '.object.sha')

jq -n \
	--arg ref "refs/heads/${protected_branch_name}" \
        --arg sha "${sha}" \
	'{ ref: $ref, sha: $sha }' > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs --data @${json_file}
