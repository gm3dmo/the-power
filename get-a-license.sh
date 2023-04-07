.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@2.20/rest/reference/licenses#get-a-license 
# GET /licenses/{license}

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    license="mit"
  else
    license=$1
fi

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/licenses/${license}
