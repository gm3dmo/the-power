.  ./.gh-api-examples.conf
./list-organizations.sh | jq '.[] | .login'
./list-organization-owners.sh | jq '.[] | .login'
./list-organization-repos.sh |  jq '.[] | .name'
./list-projects.sh preview |  jq '.[] | .name'
./list-teams.sh  | jq '.[] | .name'
./list-team-members.sh |   jq '.[] | .name'
./list-users.sh | jq '.[] | .login'
