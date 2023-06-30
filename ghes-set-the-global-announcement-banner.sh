.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/announcement#set-the-global-announcement-banner
# PATCH /enterprise/announcement

announcement="This is a test announcement from The Power."

json_file=tmp/set-the-global-announcement-banner.json


jq -n \
           --arg announcement "${announcement}" \
           '{
             announcement : $announcement
           }' > ${json_file}


curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/enterprise/announcement"  --data @${json_file}
