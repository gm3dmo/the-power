.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/announcement-banners/organizations?apiVersion=2022-11-28#set-announcement-banner-for-organization
# PATCH /orgs/{org}/announcement


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    org=$org
  else
    org=$1
fi


announcement="woo woo"
user_dismissable="true"
expires_at=$(python -c "import datetime; print((datetime.datetime.utcnow() + datetime.timedelta(days=5)).strftime('%Y-%m-%dT%H:%M:%SZ'))")


json_file=tmp/set-announcement-banner-for-organization.json
jq -n \
           --arg announcement "${announcement}" \
           --arg expires_at "${expires_at}" \
           --arg user_dismissable "${user_dismissable}" \
           '{
             announcement: $announcement,
             expires_at: $expires_at,
             user_dismissable: $user_dismissable | test("true")
           }' > ${json_file}

cat $json_file | jq -r


curl -L ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/orgs/${org}/announcement"  --data @${json_file}

