.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#download-a-repository-archive-tar
# GET /repos/{owner}/{repo}/tarball/{ref}

stamp=`date +%s`

curl ${curl_custom_flags} \
     -L \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}/tarball/" -o "tmp/${repo}-${stamp}.archive.tar"
