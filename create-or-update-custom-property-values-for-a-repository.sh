.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/custom-properties?apiVersion=2022-11-28#create-or-update-custom-property-values-for-a-repository
# PATCH /repos/{owner}/{repo}/properties/values


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


json_file=tmp/create-or-update-custom-property-values-for-a-repository.json

environment=${default_environment_name}
service="web"
team=${team_slug}

jq -n \
           --arg environment "${environment}" \
           --arg service "${service}" \
           --arg team "${team_slug}" \
           '{
 "properties":[{"property_name":"environment","value": $environment }, {"property_name":"service","value": $service },{"property_name":"team","value": "$team"}]
           }' > ${json_file}


curl -L ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/properties/values"  --data @${json_file}

