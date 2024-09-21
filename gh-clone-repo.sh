.  ./.gh-api-examples.conf

# https://cli.github.com/manual/gh_api

export GH_TOKEN=${GITHUB_TOKEN}
export GH_ENTERPRISE_TOKEN=${GITHUB_TOKEN}
export GH_HOST=${hostname}

gh repo clone ${org}/${repo}
