.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-reference
# POST /repos/:owner/:repo/git/refs

# If the script is passed an argument $1 use that as the name

if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

# We want this to always be able to create a branch so, if given no arguments 2
# it will create a branch name with a suffix of the current unix timestamp
# 

timestamp=$(date +%s)

if [ -z "$2" ]
  then
    branch_name=${branch_name}_${timestamp}
  else
    branch_name=$2
fi

json_file=tmp/create-branch-${branch_name}.json

sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${base_branch} | jq -r '.object.sha')

echo "==================" >&2
echo "(${sha})" >&2
echo "($branch_name)" >&2
echo "==================" >&2

jq -n \
   --arg ref "refs/heads/${branch_name}" \
   --arg sha "${sha}" \
   '{ ref: $ref, sha: $sha }' > ${json_file}

json_string=$(cat $json_file | jq )

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs --data "${json_string}"
