.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-reference
# POST /repos/{owner}/{repo}/git/refs

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    sha=$sha
  else
    sha=$1
fi

json_file=tmp/create-a-reference.json

ref="refs/heads/grandmasterflash2"

jq -n \
           --arg ref "${ref}" \
           --arg sha "${sha}" \
           '{
             ref : $ref,
             sha: $sha
           }' > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs --data @${json_file}
