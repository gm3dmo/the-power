.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-reference
# POST /repos/:owner/:repo/git/refs

sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/ref/heads/${base_branch} | jq -r '.object.sha')

if [ -z "$1" ]
  then
   ref=refs/head/${base_branch}
  else
    ref=$1
fi

json=tmp/create-reference.json

rm -f ${json}

jq -n \
        --arg ref "${ref}" \
        --arg sha "${sha}" \
          '{ ref: $ref,
             sha: $sha }' > ${json}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs --data @${json}

rm -f ${json}
