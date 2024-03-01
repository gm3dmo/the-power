.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path


if [ -z "$1" ]
  then
      GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')
  else
     echo 
fi

echo

ts=$(date +%s)
message="this is the commit message ${ts}"

json_file=tmp/create-commit-file.json

# with date +%s we can create a file with a timestamp in the name:
# this is useful for running in a loop and creating many files.
filename_to_create=timeserial_number-$(date +%s).md

jq -n \
          --arg message "${message}" \
          --arg committer "${committer}" \
                '{ "message": $message,   "content": "c3F1ZWFrCg==" }' > ${json_file}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${filename_to_create} --data @${json_file}
