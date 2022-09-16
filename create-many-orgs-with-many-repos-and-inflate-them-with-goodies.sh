./generate-long-list-of-orgs.pl
./generate-long-list-of-repos.pl
for org in $(cat tmp/long-list-of-orgs.txt)
do
  export org
  # do an inline edit on .gh-api-examples.conf file to switch out
  # the org name:
  perl -p -i -e 's/^org=.*/org=$ENV{org}/g' .gh-api-examples.conf
  set -x
  ./create-organization.sh
  ./create-team.sh
  ./create-org-members.sh
  ./add-users-to-team.sh
  ./add-maintainers-to-team.sh
  ./create-an-organization-webhook.sh
  for repo in $(cat tmp/long-list-of-repos.txt)
  do
       # inline edit the reponame now same as we did earlier for the org
       export repo
       perl -p -i -e 's/^repo=.*/repo=$ENV{repo}/g' .gh-api-examples.conf
       ./create-repo-testrepo.sh
       ./add-team-to-repo.sh
       ./create-webhook.sh
       ./create-commit-codeowners.sh
       ./create-commit-readme.sh
       ./create-commit-requirements.sh
       ./create-branch-newbranch.sh
       ./create-commit-on-newbranch.sh
       ./create-repo-issue.sh
       ./create-pull-request.sh
       ./create-branch-protected.sh
       ./set-branch-protection.sh
       ./create-release.sh
       ./create-pages.sh
       ./create-gist.sh
  done
done
