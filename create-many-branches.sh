.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/git#create-a-reference
# POST /repos/:owner/:repo/git/refs

timestamp=$(date +"%s")
json_file=tmp/create-branch-newbranch.json
rm -f ${json_file}

sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${base_branch} | jq -r '.object.sha')

for branch_name in $(cat tmp/longlistofbranches.txt)
do
    jq -n \
        --arg ref "refs/heads/${branch_name}" \
        --arg sha "${sha}" \
        '{ ref: $ref, sha: $sha }' > ${json_file}

    json_string=$(cat $json | jq )

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs --data "${json_string}"

    rm -f ${json_file}
done
