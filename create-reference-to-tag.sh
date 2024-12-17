.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/refs?apiVersion=2022-11-28#create-a-reference
# POST /repos/{owner}/{repo}/git/refs


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    tag_sha=$(./create-tag.sh | jq -r '.sha')
  else
    tag_sha=$1
fi

ts=$(date +%s)

ref=refs/tags/tag_fixedTest_${ts}

json_file=tmp/create-reference.json


jq -n \
                --arg ref "${ref}" \
                --arg sha "${tag_sha}" \
                '{ ref: $ref,
                  sha: $sha }'  > ${json_file}

curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs" --data @${json_file}

