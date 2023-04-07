.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/teams#create-a-team
# POST /orgs/:org/teams

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    team=$team
  else
    team=$1
fi

# If the script is passed an argument $2 use that as the org
if [ -z "$2" ]
  then
    org=${org}
  else
    org=$2
fi

privacy="closed"
#privacy="secret"


./generate-long-list-of-teams.pl

for custom_team_name in $(cat tmp/long-list-of-teams.txt)
do
  ./create-team.sh ${custom_team_name} &
  sleep 0.05
done
