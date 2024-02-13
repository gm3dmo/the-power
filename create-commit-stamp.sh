.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

# If the script is passed an argument $1 use that as the name of the repo
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi


python3 create-commit-stamp.py 

timestamp=$(date +%s)

filename_in_repo="power-stamp-${timestamp}.txt"


json_file=tmp/create-commit-stamp.json

curl ${curl_custom_flags} \
     -X PUT \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename_in_repo} --data @${json_file}
