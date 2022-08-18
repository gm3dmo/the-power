## Configuring The Power

### Prerequisites
* Linux/Mac/GitHub Codespace
* A GitHub Enterprise Server or dotcom org with a Enterprise admin user name and password 
* A `jq` command. `brew install jq` on your client.
* A Python >3.6 interpreter on your Mac.
* [Create your token](1). In GitHub Enterprise (give it all the scopes. Be careful and give the token an expiry date if running on GitHub.com. Strongly recommend a token with short expiry time.

### Setup

### Client side setup
- Download the [latest release](https://ghe.io/gm3dmo/the-power/releases/latest).
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


### Configure can run without interation
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

### Applying a build to an organization on GitHub.com

```
bash build-testcase
```

