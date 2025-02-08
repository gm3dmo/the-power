.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/git/refs?apiVersion=2022-11-28#create-a-reference
# POST /repos/{owner}/{repo}/git/refs


timestamp=$(date +"%s")
sha=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs/heads/${base_branch} | jq -r '.object.sha')

for branch_name in $(cat tmp/longlistofbranches.txt)
do
    json_file=tmp/create-branch.json
    jq -n \
        --arg ref "refs/heads/${branch_name}" \
        --arg sha "${sha}" \
        '{ ref: $ref, sha: $sha }' > ${json_file}


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/refs" --data "@${json_file}"
done

