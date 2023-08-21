.  ./.gh-api-examples.conf


issue=1
for team_member in ${team_members}
do
  bash create-issue-comment-impersonating.sh 1 ${team_member}
done
