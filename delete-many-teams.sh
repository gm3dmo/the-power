.  ./.gh-api-examples.conf

for custom_team_name in $(cat nato-alphabet.txt)
do
  ./delete-team.sh ${custom_team_name}
done
