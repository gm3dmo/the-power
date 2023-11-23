.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/rest/enterprise-admin/audit-log
# GET /enterprises/{enterprise}/audit-log


# CAVEAT: The documentation at:
# https://docs.github.com/en/enterprise-server@3.3/admin/monitoring-activi
# ty-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/using-the
# -audit-log-api-for-your-enterprise#example-1-all-events-in-an-enterprise
# -for-a-specific-date-with-pagination for GHES does not correctly
# demonstrate the use of the endpoint because it uses `api.github.com`
# and does not use `api/v3` prefixed to the api endpoint of
# /enterprises/${enterprise}. The second missing part of the documentation
# is that on GHES the enterprise is almost always `github` this comes
# through a field in license file and cannot be changed by end users of
# the appliance.

curl ${curl_custom_flags} \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
       "${GITHUB_API_BASE_URL}/enterprises/${enterprise}/audit-log?phrase=created:>2022-10-01..2022-10-14&page=1&per_page=1"
