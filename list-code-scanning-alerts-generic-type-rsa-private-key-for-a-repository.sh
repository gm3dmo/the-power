.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/secret-scanning/secret-scanning?apiVersion=2022-11-28#list-secret-scanning-alerts-for-a-repository
# GET /repos/{owner}/{repo}/secret-scanning/alerts

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    generic_secret_type=rsa_private_key
  else
    generic_secret_type=$1
fi


set -x
curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/secret-scanning/alerts?secret_type=${generic_secret_type}"
