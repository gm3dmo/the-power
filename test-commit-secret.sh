
.  ./.gh-api-examples.conf

This script is intended to run after build-testcase-secret-scanning


cd src/${repo}
# We split the token in 2 so that it's never checked in to the power
# in a way that will set off a false positive (hopefully).

# Breaking tokens up to get past a secret scanner is a bad thing
# it will likely get you fired.

gh1=ghp_9
gh2=gDO8kvREKK9toy7CsUunZEY77XvGA1pNv5F

google_api1="AIzaSyDxJB-"
google_api2="2ocxX02LIAZiU_2_0bhhc2wDlN8g"

azure_storage_1="e6ZZx75Z6095KHJvBZIDOD9kCLt3KjHx/"
azure_storage_2="KKT0LWi25F+Cq0XxlpS+tbs1EqlqvRY3YgC19T5+PC6+AStjkFjyQ=="



function github_pat () { 
    echo "Commit: GITHUB PAT"
    echo export GITHUB_TOKEN=${gh1}${gh2} >github.token.compromised.secret.txt
}
function google_api_key () {
    echo "Commit: google_api_key"
    echo "${google_api1}${google_api2}"   >google_api_key.compromised.secret.txt
}

function azure_storage () {
    echo "Commit: azure_storage"
    echo "${azure_storage_1}${azure_storage_2}"   >azure_storage.compromised.secret.txt
}


case $1 in 
 github)
    github_pat
    ;;
 google_api_key)
    google_api_key 
    ;;
 azure_storage)
    azure_storage
    ;;
 all)
    github_pat
    google_api_key 
    azure_storage
    ;;
 *)
   echo 
   echo "Please pass a name of token to compromise: [ azure_storage, github, google_api_key ]"
   echo 
   ;;
esac


git add *.txt
git commit -m "Adding compromised keys keys."
echo
echo press enter to push commit with secret:
echo
read x
git push
