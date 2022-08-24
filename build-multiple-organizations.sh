# Create the organizations
./create-organizations.sh
exit
./create-team.sh
./create-team.sh closed
./create-team.sh secret
./create-users.sh
./create-org-members.sh
./add-users-to-team.sh
./add-maintainers-to-team.sh

./create-an-organization-webhook.sh
./create-organization-project.sh preview
./create-organization-project-columns.sh preview
./add-team-to-org-project.sh

# Create the testrepo
./create-repo-testrepo.sh
./create-webhook.sh
./create-commit-readme.sh
./create-commit-codeowners.sh
./create-commit-requirements.sh
./add-team-to-repo.sh

./create-branch-newbranch.sh
./create-commit-on-newbranch.sh

./pride-patch-labels.sh

./create-repo-issue.sh
./create-pull-request.sh

./create-branch-protected.sh
./set-branch-protection.sh

./create-release.sh

./create-pages.sh
./create-gist.sh

# Create and populate testrepo-public
./create-repo.sh testrepo-public public
./create-repo.sh hook-repo public

# Add team and commits to the repo:
./add-team-to-repo.sh testrepo-public
./create-webhook.sh testrepo-public
./create-commit-readme.sh testrepo-public
./create-commit-pom.sh testrepo-public
./create-commit-codeowners.sh testrepo-public

./create-branch-newbranch.sh testrepo-public
./create-commit-on-newbranch.sh testrepo-public

./create-branch-protected.sh testrepo-public
./set-branch-protection.sh testrepo-public

./create-repo.sh testrepo-private private
# On 2.20 and above an "internal" repository is supported.
./create-repo.sh testrepo-internal internal
