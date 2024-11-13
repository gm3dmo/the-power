.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@3.14/admin/monitoring-activity-in-your-enterprise/exploring-user-activity-in-your-enterprise/accessing-reports-for-your-instance#downloading-reports-programmatically

curl -v -u ${admin_user}:${GITHUB_TOKEN} \
        "https://${hostname}/stafftools/reports/all_users.csv"  -o tmp/all_users.csv
