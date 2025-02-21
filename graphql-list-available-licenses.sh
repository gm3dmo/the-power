.  ./.gh-api-examples.conf

# https://docs.github.com/en/graphql/reference/objects#enterprisebillinginfo

read -r -d '' graphql_script <<- EOF
{
  enterprise(slug: "$enterprise") {
    name
    billingInfo {
      totalLicenses
      totalAvailableLicenses
      allLicensableUsersCount
      assetPacks
      storageQuota
      storageUsage
      bandwidthQuota
      bandwidthUsage
    }
  }
}
EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_APIV4_BASE_URL}" -d "{ \"query\": \"$graphql_script\"}"

