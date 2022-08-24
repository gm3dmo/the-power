# if we flag to build optional: build-all.sh optional then 
# add any extra goodies to the else section:

set -x

if [ -z "$1" ]
   # Create the organization
   ./create-organization.sh
   ./create-team.sh
   ./create-users.sh
   ./create-org-members.sh
   ./add-users-to-team.sh
   ./add-maintainers-to-team.sh
   ./create-an-organization-webhook.sh
   # Create the testrepo
   ./create-repo-testrepo.sh
   ./create-webhook.sh
   ./create-commit-codeowners.sh
   ./create-commit-readme.sh
   ./create-commit-requirements.sh
   ./add-team-to-repo.sh
   ./create-branch-newbranch.sh
   ./create-commit-on-newbranch.sh
   ./create-repo-issue.sh
   ./create-pull-request.sh
   ./create-branch-protected.sh
   ./set-branch-protection.sh
   ./create-release.sh
   
   ./create-pages.sh
   ./create-gist.sh
  then
     >&2 echo "No optionals being run"
  else
    # Put a case statement in here
    # Renders
    ./create-commit-test-rst.sh
    ./create-commit-test-ipynb.sh

    # Projects
    ./create-organization-project.sh preview
    ./create-organization-project-columns.sh preview
    ./add-team-to-org-project.sh

    # Pride labels
    ./pride-patch-labels.sh

    # Precommit hooks
    ./create-repo.sh hook-repo public
    ./create-commit-pre-hook.sh hook-repo
fi
