.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/issues/milestones?apiVersion=2022-11-28#delete-a-milestone
# DELETE /repos/{owner}/{repo}/milestones/{milestone_number}


if [ -z "$1" ]
  then
    milestone_number=$(./list-milestones.sh| jq '[.[].number] | max' )
  else
    milestone_number=$1
fi


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/milestones/${milestone_number}"

