.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-blob
# POST /repos/{owner}/{repo}/git/blobs

# If the script is passed an argument $1 use that as the name for the target repo
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

content="lorem ipsum"

json_file=tmp/create-blob.json

jq -n \
        --arg content "${content}" \
'{ content: $content }'  > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/blobs --data @${json_file}
