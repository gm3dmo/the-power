.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server/admin/configuration/configuring-your-enterprise/site-admin-dashboard

curl -v -u ${admin_user}:${GITHUB_TOKEN} \
        https://${hostname}/stafftools/reports/all_users.csv  -o tmp/all_users.csv


