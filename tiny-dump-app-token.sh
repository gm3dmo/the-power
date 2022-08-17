. .gh-api-examples.conf

GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token')
echo "+++++++++++++++++++++++++++++++++++++++++++++" >&2
printf  "    App token: " >&2
echo ${GITHUB_TOKEN} 
echo "+++++++++++++++++++++++++++++++++++++++++++++" >&2
