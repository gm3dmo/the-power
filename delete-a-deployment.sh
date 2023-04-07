.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#delete-a-deployment
# DELETE /repos/{owner}/{repo}/deployments/{deployment_id}




if [ -z "$1" ]
  then
    deployment_id=${default_deployment_id}
  else
    deployment_id=$1
fi

curl  ${curl_custom_flags} \
     -X DELETE \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/deployments/${deployment_id}
