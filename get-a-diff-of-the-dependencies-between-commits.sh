. .gh-api-examples.conf

# https://docs.github.com/en/rest/dependency-graph/dependency-review#get-a-diff-of-the-dependencies-between-commits
# GET /repos/{owner}/{repo}/dependency-graph/compare/{basehead}

# if argument $1 is passed use that as variable head

if [ -z "$1" ]
then
  head=$(./list-commits-on-repo.sh | jq -r '.[0].sha')
else
  head="$1"
fi

# if argument $2 is passed use that as a variable base

if [ -z "$2" ]
then
  base="$(./list-commits-on-repo.sh | jq -r '.[-1].sha')"
else
  base="$2"
fi

# format the basehead variable

basehead=(${base}...${head})

# send a request to GitHub API

set -x
curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/dependency-graph/compare/${basehead}

