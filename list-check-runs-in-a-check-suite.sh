
.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/checks/runs#list-check-runs-in-a-check-suite
# GET /repos/{owner}/{repo}/check-suites/{check_suite_id}/check-runs


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    check_suite_id=1
  else
    check_suite_id=$1
fi


# Check suite_id is obtained from:


GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')


set -x
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-suites/${check_suite_id}/check-runs


