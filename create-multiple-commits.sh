.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

if [ -z "$2" ]
  then
    number_of_files_required=10
  else
    number_of_files_required=$2
fi


timestamp=$(date +%s)


for file_number in $(seq 1 ${number_of_files_required})
do

   curl ${curl_custom_flags} \
        -X PUT \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
           ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/docs/README_${timestamp}_${file_number}.md --data @create-commit-readme.json

done
