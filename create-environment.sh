. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-an-environment
# PUT /repos/{owner}/{repo}/environments/{environment_name}

environment_name=${default_environment_name}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/environments/${environment_name} --data '{"wait_timer":10}'
