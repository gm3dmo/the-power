.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/blobs?apiVersion=2022-11-28#create-a-blob
# POST /repos/{owner}/{repo}/git/blobs


# If the script is passed an argument $1 use that as the name for the target repo
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

# For secret scanning and push protection place a scret in ${lorem_file}
lorem_file="test-data/lorem-blob.txt"
lorem_text=$(cat $lorem_file)

json_file=tmp/create-a-blob.json
jq -n \
        --arg content "${content}" \
'{ content: $content }'  > ${json_file}


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/blobs" --data @${json_file}

