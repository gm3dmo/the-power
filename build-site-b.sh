# Create the organization
./create-organization.sh site-b

./create-team.sh closed site-b
./create-plain-users.sh site-b
./create-site-b-members.sh site-b

./create-repo.sh testrepo-aaa internal site-b
./create-repo.sh testrepo-bbb internal site-b
