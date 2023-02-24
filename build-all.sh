
if [ -z "$1" ]
   printf "Creating organization: "
    ./create-organization.sh | jq -r '.url'
   printf "Creating organization webhook: "
    ./create-an-organization-webhook.sh | jq -r '.id'
   printf "Creating team:\n"
   ./create-team.sh | jq -r '.html_url'
   printf "Creating users:\n"
   ./pwr-create-users.sh
   printf "Creating org members:\n"
   ./pwr-create-org-members.sh 
   printf "Adding users to team:\n"
   ./pwr-add-users-to-team.sh | jq -r '.url'
   printf "Adding maintainers to team:\n"
   ./add-maintainers-to-team.sh | jq -r '.url'
   printf "Creating repo: "
    ./create-repo-testrepo.sh | jq -r '.html_url'
    ./add-team-to-repo.sh
   printf "Creating webhook: "
    ./create-webhook.sh  | jq -r '.id'
   printf "Creating docs/README: "
    ./create-commit-readme.sh | jq -r ".content.html_url"
   printf "Creating CODEOWNERS: "
    ./create-commit-codeowners.sh| jq -r ".content.html_url"
   printf "Creating requirements.txt: "
    ./create-commit-python-pip.sh| jq -r ".content.html_url"
    sleep 2.5
   printf "Creating new branch: "
    ./create-branch-newbranch.sh | jq -r '.url'
   printf "Creating a commit on the new branch: "
    ./create-commit-on-new-branch.sh | jq -r ".content.html_url"
   printf "Creating an issue: "
    ./create-repo-issue.sh | jq -r '.html_url'
   printf "Creating a pull request: "
    ./create-pull-request.sh | jq -r '.html_url'
    # set the branch protection rules for main
   printf "Setting branch protection rules on default branch: "
    ./set-branch-protection.sh | jq -r '.url'
   printf "Creating a release: "
    ./create-release.sh  | jq -r '.url'
   printf "Adding a .gitattributes file to new branch: "
    ./create-commit-gitattributes.sh | jq -r ".content.html_url"

  then
     >&2 echo "No optionals being run"
  else
     # Pages & Gist
    ./create-pages.sh
    ./create-gist.sh

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
