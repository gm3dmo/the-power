
. .gh-api-examples.conf

# https://docs.github.com/en/rest/checks/runs#list-check-runs-in-a-check-suite
# GET /repos/{owner}/{repo}/check-suites/{check_suite_id}/check-runs

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


check_suite_id=8097066121

GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-suites/${check_suite_id}/check-runs


