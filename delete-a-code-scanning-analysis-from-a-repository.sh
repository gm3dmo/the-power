.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/code-scanning?apiVersion=2022-11-28#delete-a-code-scanning-analysis-from-a-repository
# DELETE /repos/{owner}/{repo}/code-scanning/analyses/{analysis_id}


analysis_id=$1

curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/code-scanning/analyses/${analysis_id}

