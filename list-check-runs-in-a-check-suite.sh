
.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/checks/runs?apiVersion=2022-11-28#list-check-runs-in-a-check-suite
# GET /repos/{owner}/{repo}/check-suites/{check_suite_id}/check-runs


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    check_suite_id=$(./list-check-suites-for-a-git-reference.sh | jq '[.check_suites[].id] | min')
  else
    check_suite_id=$1
fi


GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')
curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/check-suites/${check_suite_id}/check-runs"

