.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/branches/branch-protection#get-branch-protection
# GET /repos/{owner}/{repo}/branches/{branch}/protection

if [ -z "$1" ]
  then
    branch=${base_branch}
  else
    branch=$1
fi


#set -x
#while :
#do

#    sleep 0.1
    curl  ${curl_custom_flags} \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches/${branch}/protection 
#done
