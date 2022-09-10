## Contributing to The Power

If you want to contribute then pull requests are awesome and very welcome. The things in in The Power that I like the most were mostly suggested by others and we'd love to hear them in the [Discussions](https://github.com/gm3dmo/the-power/discussions).

### Writing `The Power` scripts
If you are keen on writing a script, then following the guidance below should help with the smooth handling of your pull request:

#### Keep it portable

- DO NOT make calls of non-portable utilites like `grep, sed, awk`. This preserves the clarity of the scripts in The Power.
- DO write a [`python 3.9`, `ruby 2.6`] script where essential complexity needs to be handled.
- DO use the `tmp` directory provided with The Power.
- DO NOT use the `/tmp` directory common on Unix derived systems. This helps to preserve the ability to be isolated and run in containers and other target operating systems.
- DO clone repositories to the `src` directory.
- DO add artifacts the script needs to the `test-data` directory. Please use an underscore `_` as the suffix, for example `test-data/class-diagram.md_` to prevent the [class-diagram.md_](https://github.com/gm3dmo/the-power/blob/main/test-data/class-diagram.md_) file in The Power's own repository from being rendered by GitHub. See [create-commit-rust-cargo-lock.sh]([source_file="test-data/rust/cargo/Cargo.lock_](https://github.com/gm3dmo/the-power/blob/main/create-commit-rust-cargo-lock.sh)" for example. 
)

Scripts MUST follow this very simple structure:

- Line 1: Read in the config file: `. .gh-api-examples.conf`
- Line 2: A blank line.
- Line 3: A comment character followed by a space: `#`, a link to the documentation for the endpoint.
- Line 4: A comment character followed by a space followed by the the call. 
- Optional: Choice of target, such as `repo` to be passed via the command line or revert to a default value.
- Any other custom logic needed to prepare the call.
- A curl command against the target API endpoint.

A [`skeleton.sh`](https://github.com/gm3dmo/the-power/blob/main/skeleton.sh_) sample is provided for reference.

#### Example: Adding a script for The Codespaces API

To add a new script for a REST API endpoint like [codespaces](https://docs.github.com/en/rest/codespaces/codespaces).

1. Copy the skeleton file to a file with the name of the API call (get this from the documetation title)

```
cp skeleton.sh_ list-codespaces-in-a-repository-for-the-authenticated-user.sh
```

2. Edit `list-codespaces-in-a-repository-for-the-authenticated-user.sh`, replace URL on line 3 with:

```
https://docs.github.com/en/rest/codespaces/codespaces#list-codespaces-in-a-repository-for-the-authenticated-user
```

3. Replace CALL with (this can be found in the API documentation:

```
GET /repos/{owner}/{repo}/codespaces
```

```bash
. .gh-api-examples.conf

# URL
# CALL


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

For `GET` request types, we can remove the:

```bash
`json_file=tmp/skeleton.json`
```

and `jq` command:

```bash
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

Replace the url:

```bash
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
