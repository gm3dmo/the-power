## Contributing to The Power

Scripts in The Power have a very simple structure:

- read in the config file.
- link to the GitHub API documentation for the API endpoint.
- the call and url being used. 
- an option choice of target like repository to be passed via the command line
- any other customer logic needed to prepare the call.
- a curl command against the API endpoint.

### Example: Adding Codespaces coverage:

To add a new script for a REST API endpoint like [codespaces](https://docs.github.com/en/rest/codespaces/codespaces).

Copy the skeleton file to a file with the name of the API call (get this from the documetation title)

```
cp skeleton.sh_ list-codespaces-in-a-repository-for-the-authenticated-user.sh
```

Edit `list-codespaces-in-a-repository-for-the-authenticated-user.sh`, replace URL on line 3 with:

```
https://docs.github.com/en/rest/codespaces/codespaces#list-codespaces-in-a-repository-for-the-authenticated-user
```

Replace CALL with (this can be found in the API documentation:

```
GET /repos/{owner}/{repo}/codespaces
```

```
. .gh-api-examples.conf

# URL
# CALL
#
#
#
# If the script is passed an argument $1 use that as the name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

json_file=tmp/skeleton.json

jq -n \
           --arg name "${repo}" \
           '{
             name : $name,
           }' > ${json_file}

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL} --data @${json_file}
```

As its a GET request type, we can remove the json_file and jq lines.

Replace the url:

```
. .gh-api-examples.conf

# https://docs.github.com/en/rest/codespaces/codespaces#list-codespaces-in-a-repository-for-the-authenticated-user
# GET /repos/{owner}/{repo}/codespaces

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: token ${GITHUB_TOKEN}" \
     ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/codespaces
```


Change `${owner}` to `${org}`:

```
/repos/${org}/{repo}/codespaces
```

Change `{repo}` to `${repo}`

Submit the change in a pull request.
