. .gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path

# Run this `create-log4j-pom-xml.py` to generate the `log4j-pom-xml.json` file for upload to the repo.

# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/src/main/java/com/mycompany/app/App.java --data @tmp/App.java.json

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/src/test/java/com/mycompany/app/AppTest.java --data @tmp/AppTest.java.json
