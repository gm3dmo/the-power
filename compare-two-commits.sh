.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/commits/commits#compare-two-commits
# GET /repos/{owner}/{repo}/compare/{basehead}

# If the script is passed an argument $1 use that as the head sha

if [ -z "$1" ]
  then
    head=$(./list-commits-on-repo.sh | jq -r '.[1] .sha')
  else
    head=$1
fi

basehead=(${base_branch}...${head})

curl -v ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/compare/${basehead}
     
