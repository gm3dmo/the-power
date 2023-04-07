.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path


# Run this `create-log4j-pom-xml.py` to generate the `log4j-pom-xml.json` file for upload to the repo:
python3 create-log4j-json-file.py

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

for i in $(seq 1 9)
do
  i=$(printf %05d ${i})
  echo $i
  curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/dir-${i}/pom.xml --data @tmp/log4j-pom-xml.json
done
