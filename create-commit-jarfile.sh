.  ./.gh-api-examples.conf


json_file=tmp/create-commit-jarfile.json
jarfile_name_in_repo=binks.jar

python3 create-commit-jarfile.py --branch-name ${branch_name}

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${jarfile_name_in_repo}" --data @${json_file}

