## Configuring The Power

### Prerequisites
* Linux/Mac/GitHub Codespace
* A GitHub Enterprise Server or dotcom org with a Enterprise admin user name and password 
* A `jq` command. `brew install jq` on your client.
* A Python >3.6 interpreter on your Mac.
* The [JWT Rubygem](https://rubygems.org/gems/jwt). `sudo gem install jwt` - Required for [GitHub App authentication](https://github.com/gm3dmo/the-power/blob/main/docs/setting-up-a-gh-app.md#using-a-github-app-with-the-power).
* [Create your token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token). In GitHub Enterprise (give it all the scopes. Be careful and give the token an expiry date if running on GitHub.com. Strongly recommend a token with short expiry time. If creating a lot of tokens, then this tip for [selecting all checkboxes on](https://gist.github.com/gm3dmo/e085294a622c1c72eec0e8b48d72b092) may be useful.

### Setup

### Client side setup
- Download the [latest release](https://github.com/gm3dmo/the-power/releases/latest).
- Unzip the release file to a directory of your choice.
- Change into the the directory and version of the power.
- Run [`configure.py`](/configure.py) to generate the `.gh-api-examples.conf` file. This file feeds variables to the scripts in The Power.:

```
$ python3 configure.py
```

`configure.py` asks questions, You need to provide your token and hostname of your
GHE server or enter `api.github.com` if you are using GitHub.com enter `api.github.com` as the hostname.

```
Enter GHE Hostname: myserver.example.com
Enter token: ***cc2d128a
```

* If you want a different team name,  you can edit  `.gh-api-examples.conf` with an editor of your choice.


### `configure.py` can run without interaction from the command line:
Non-interactive values can be specified on the command line in order to use The Power in a custom automation:

```
python3 configure.py --hostname myserver.example.com \
                     --token ghp_****************************wh3Ybleu \
                     --webhook-url https://events.hookdeck.com/e/src_1hm2RSyiguMW
```
The `--primer` flag may also be of interest. Provide the name of a primer script which will be executed when `configure.py` is complete.

Optionally, edit  `.gh-api-examples.conf` to add any extra customizations you want to support.


### Applying a build to a GHE server

```
bash build-all.sh
```

#### Screen recording `build-all.sh` on GitHub Enterprise Server

[![asciicast](https://asciinema.org/a/QMvQI0AcRUCpTzmxUW4GQB0GX.svg)](https://asciinema.org/a/QMvQI0AcRUCpTzmxUW4GQB0GX)

### Applying a build to an organization on GitHub.com

```
bash build-testcase
```

#### Screen recording build-testcase on GitHub.com

[![asciicast](https://asciinema.org/a/djiHmfyYAFhCKlfuWLbACZrrf.svg)](https://asciinema.org/a/djiHmfyYAFhCKlfuWLbACZrrf)
