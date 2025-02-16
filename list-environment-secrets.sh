.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/actions/secrets?apiVersion=2022-11-28#list-environment-secrets
# GET /repositories/{repository_id}/environments/{environment_name}/secrets

# check repo_id versus repo

if [ -z "$1" ]
  then
   environment_name=${default_environment_name}
  else
   environment_name=$1
fi

if [ -z "$1" ]
  then
   repo=$repo
  else
   repo=$2
fi

repository_id=$(./list-repo.sh $repo | jq -r '.id')

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repositories/${repository_id}/environments/${environment_name}/secrets"

