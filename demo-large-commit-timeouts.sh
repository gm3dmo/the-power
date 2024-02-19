.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28#get-a-commit
# GET /repos/{owner}/{repo}/commits/{ref}

ref=$1


# Get the gutenberg copy of "War and Peace" (about 3mb text file)
# cp test-data/war-and-peace.txt src/repo/sourcefile.txt
# Create 1000 copies of war and peace to their own numbered files:
# perl -e 'for my $i (1..1000) { system("cp sourcefile.txt " . sprintf("destinationfile_%04d.txt", $i)); }'
# git add '*.txt'
# git commit
# note the commit and pass it to this script


curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/commits/${ref}" > json.json

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.diff+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/commits/${ref}" > diff_json.json

curl ${curl_custom_flags} \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3.patch+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${owner}/${repo}/commits/${ref}" > patch_json.json

