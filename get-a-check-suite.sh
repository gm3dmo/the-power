.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/checks/suites?apiVersion=2022-11-28#get-a-check-suite
# GET /repos/{owner}/{repo}/check-suites/{check_suite_id}


if [ -z "$1" ]
  then
    check_suite_id=1
  else
    check_suite_id=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/check-suites/{check_suite_id}"

