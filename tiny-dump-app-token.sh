.  ./.gh-api-examples.conf


# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    GITHUB_TOKEN=$(./tiny-call-get-installation-token.sh | jq -r '.token' 2>/dev/null)
  else
    GITHUB_TOKEN=1
fi



echo "++++++++++++++++++++++ App Token ++++++++++++++++++++++" >&2
echo  >&2
echo ${GITHUB_TOKEN} 
echo  >&2
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++" >&2
