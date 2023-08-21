.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-server@2.20/admin/configuration/site-admin-dashboard#reports
# The default for this script is `all_users`. To access others,
# replace all_users with active_users, dormant_users, suspended_users,
# all_organizations, or all_repositories 

if [ -z "$1" ]
  then
    report="all_users"
  else
    report=$1
fi

curl -L -v -u ${admin_user}:${GITHUB_TOKEN} \
        https://${hostname}/stafftools/reports/${report}.csv  -o ${report}.csv

