.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/dependency-graph/dependency-review?apiVersion=2022-11-28#get-a-diff-of-the-dependencies-between-commits
# GET /repos/{owner}/{repo}/dependency-graph/compare/{basehead}


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


#basehead="2156e9ba0f3ec66544189b1b15fa8e3474dcd0fe...ffaf13e998cc376175965f0549fdd2abd324a6e0"
basehead="ffaf13e998cc376175965f0549fdd2abd324a6e0...7d069871c2c39850aa3a4e1be7acbb8aa8f7103f"

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/dependency-graph/compare/${basehead}"

