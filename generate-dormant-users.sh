.  ./.gh-api-examples.conf

curl -L -v -u ${admin_user}:${GITHUB_TOKEN} \
        https://${hostname}/stafftools/reports/dormant_users.csv  -o tmp/all_users.csv


