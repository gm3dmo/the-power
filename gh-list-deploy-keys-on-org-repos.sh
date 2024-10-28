.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api

export GH_TOKEN=${GITHUB_TOKEN}
#export GH_ENTERPRISE_TOKEN=${GITHUB_TOKEN}
#export GH_HOST=${hostname}


for repo_name in $(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /orgs/${owner}/repos --jq '.[].full_name' -X GET --paginate)
do
    gh repo -R ${repo_name} deploy-key list;\
done
