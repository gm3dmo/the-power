.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/announcement#get-the-global-announcement-banner
# DELETE /enterprise/announcement


curl ${curl_custom_flags} \
     -X DELETE \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
         "${GITHUB_API_BASE_URL}/enterprise/announcement"
