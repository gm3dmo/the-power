
.  ./.gh-api-examples.conf

# This script is intended to run after build-testcase-secret-scanning

cd src/${repo}
# We split the token in 2 so that it's never checked in to the power
# in a way that will set off a false positive (hopefully).

# Breaking tokens up to get past a secret scanner is a bad thing
# it will likely get you fired.


if [ -z "$1" ]
  then
    keyname=all
  else
    keyname=$1
fi

function github_pat () { 
    gh1=ghp_9
    gh2=gDO8kvREKK9toy7CsUunZEY77XvGA1pNv5F
    echo "Commit: GitHub PAT"
    echo export GITHUB_TOKEN=${gh1}${gh2} >github.token.compromised.secret.txt
}

function gh_app_installation () { 
    gh1=ghs_
    gh2=XJWCkil21UxGYF9ZPe4Khtf2AdKOH137s09t
    echo "Commit: GitHub App Installation Access Token"
    echo export GITHUB_TOKEN=${gh1}${gh2} >github.app-installation-access-token.compromised.secret.txt
}

function aws_access_key_id () { 
    gh1=AKIARAR
    gh2=N6AUAF3VHDJQJ
    echo "Commit: AWS Access key ID"
    echo export AWS_ACCESS_KEY_ID=${gh1}${gh2} >aws-access-key-id.compromised.secret.txt
}

function aws_secret_access_key () { 
  
    gh1=YgTGNtWY0W++
    gh2=ZoDq9WfnreJ2WWscxwUksP3OlkS2
    echo "Commit: AWS Secret Access Key"
    echo export AWS_SECRET_ACCESS_KEY=${gh1}${gh2} >aws-secret-access-key.compromised.secret.txt
}

function aws_secret_access_key_id_combo () { 
    # This will trigger GitHub push protection
    
    gh1=YgTGNtWY0W++
    gh2=ZoDq8WfnreJ2WWscxwUksP3OlkS2
    echo "Commit: AWS Secret Access key"
    gh3=AKIARAR
    gh4=N6AUAF3VHDJQJ
    echo "Commit: AWS Access key ID"
    echo export AWS_ACCESS_KEY=${gh1}${gh2} >aws-secret-access-key-id-combo.compromised.secret.txt
    echo export AWS_SECRET_ACCESS_KEY=${gh3}${gh4} >>aws-secret-access-key-id-combo.compromised.secret.txt
}

function google_api_key () {
    google_api1="AIzaSyDxJB-"
    google_api2="2ocxX02LIAZiU_2_0bhhc2wDlN8g"
    echo "Commit: google_api_key"
    echo "${google_api1}${google_api2}" >google_api_key.compromised.secret.txt
}


function azure_storage () {
    azure_storage_1="e6ZZx75Z6095KHJvBZIDOD9kCLt3KjHx/"
    azure_storage_2="KKT0LWi25F+Cq0XxlpS+tbs1EqlqvRY3YgC19T5+PC6+AStjkFjyQ=="
    echo "Commit: azure_storage"
    echo "${azure_storage_1}${azure_storage_2}" >azure_storage.compromised.secret.txt
}


function npm_granular () {
    npm_g1="npm_0QWV3DXVrcBZR"
    npm_g2="srwh1ovdBWl2kjOtH0GzmRc"
    echo "Commit: npm_granular"
    echo "${npm_g1}${npm_g2}" >npm_granular.compromised.secret.txt
}


function npm_classic () {
    npm_c1="npm_Fxg6NNBNSxFDTfAQ"
    npm_c2="pWABbI87Bl6laH1Mk1dH"
    echo "Commit: npm_classic"
    echo "${npm_c1}${npm_c2}" >npm_classic.compromised.secret.txt
}


case ${keyname} in 
 github)
    github_pat
    ;;
 google_api_key)
    google_api_key 
    ;;
 azure_storage)
    azure_storage
    ;;
 npm_granular)
    npm_granular
    ;;
 npm_classic)
    npm_classic
    ;;
 all)
    #github_pat
    #gh_app_installation
    #google_api_key
    #azure_storage
    #npm_granular
    #npm_classic
    #aws_access_key_id
    #aws_secret_access_key
    aws_secret_access_key_id_combo
    ;;
 *)
   echo 
   echo "Please pass a name of token to compromise: [ azure_storage, github, google_api_key, npm_granular, gh_app_installation, aws_access_key_id, aws_secret_access_key, aws_secret_access_key_id_combo ]"
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
