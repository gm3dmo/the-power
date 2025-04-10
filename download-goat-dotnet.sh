.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#download-a-repository-archive-zip
# GET /repos/{owner}/{repo}/zipball/{ref}

goat_org=octodemo-resources
goat_repo=webgoat_dotnet_7

goat_archive=${goat_repo}.archive.zip

curl -v ${curl_custom_flags} \
     -L \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${goat_org}/${goat_repo}/zipball/${base_branch}" -o "tmp/${goat_archive}"


cd src/${repo}
pwd
unzip ../../tmp/${goat_archive}
cd ..
mv $repo/octodemo-resources-webgoat_dotnet_7-696c48e/* ${repo}
#rmdir ${repo}/WebGoat-WebGoat-4ba8185
cd ${repo}

git add *
git commit -m "Adding the goat dotnet7 app."
echo
echo press enter to push commit with goat:
echo
read x
git push
