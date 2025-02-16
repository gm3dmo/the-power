.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/packages/packages?apiVersion=2022-11-28#list-packages-for-an-organization
# GET /orgs/{org}/packages

if [ -z "$1" ]
  then
    package_type=${default_package_type}
  else
    package_type=$1
fi


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/packages?package_type=${package_type}"

