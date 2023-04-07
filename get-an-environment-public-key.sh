.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/actions#get-an-environment-public-key
# GET /repositories/{repository_id}/environments/{environment_name}/secrets/public-key

# If the script is passed an argument $1 use that as the environment name
if [ -z "$1" ]
  then
   environment_name=${default_environment_name}
  else
   environment_name=$1
fi

# If the script is passed an argument $1 use that as the environment name
if [ -z "$1" ]
  then
   repo=$repo
  else
   repo=$2
fi

repository_id=$(./list-repo.sh $repo | jq -r '.id')

curl --silent ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repositories/${repository_id}/environments/${environment_name}/secrets/public-key
