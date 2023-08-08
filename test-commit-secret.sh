.  ./.gh-api-examples.conf
cd src/${repo}
# We split the token in 2 so that it's never checked in to the power
# in a way that will set off a false positive (hopefully).
gh1=ghp_9
gh2=gDO8kvREKK9toy7CsUunZEY77XvGA1pNv5F

google_api1="AIzaSyDxJB-"
google_api2="2ocxX02LIAZiU_2_0bhhc2wDlN8g"

echo export GITHUB_TOKEN=${gh1}${gh2} >github.token.compromised.secret.txt
echo "${google_api1}${google_api2}"   >google_api_key.compromised.secret.txt

git add *.txt
git commit -m "Adding all the keys."
echo ready to push commit with secret?
read x
git push
