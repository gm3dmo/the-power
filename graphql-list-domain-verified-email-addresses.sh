.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects 
# organizationVerifiedDomainEmails
# https://github.blog/changelog/2020-05-19-api-support-for-viewing-organization-members-verified-email-addresses/


read -r -d '' graphql_script <<- EOF
{
organization(login:"$org"){
  membersWithRole(first:100){
    nodes{
      login
      organizationVerifiedDomainEmails(login:"$org")
    }
  }
}
}
EOF

graphql_script="$(echo ${graphql_script//\"/\\\"})"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d "{ \"query\": \"$graphql_script\"}"

