.  ./.gh-api-examples.conf


for team_member in ${team_members}
do
 ./create-ssh-key-and-upload-impersonating.sh $team_member
done

