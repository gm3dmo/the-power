## Configuring The Power

### Prerequisites
* A GitHub Enterprise Server or dotcom org with a Enterprise admin user name and password 
* A `jq` command. `brew install jq` on your Mac.
* A Python >3.6 interpreter on your Mac.
* [Create your token](1). In GitHub Enterprise (give it all the scopes. Be careful and give the token an expiry date if running on GitHub.com.

### Setup

### Client side setup
- Download the [latest release](https://ghe.io/gm3dmo/the-power/releases/latest).
- Unzip the release file to a directory of your choice.
- Change into the the directory and version of the power.
- Run [`configure.py`](configure.py) to generate the `.gh-api-examples.conf` file. This file feeds variables to the scripts in The Power.:

```
$ python3 configure.py
```


`configure.py` asks 2 questions, You need to provide your token and hostname of your
GHE server or enter `api.github.com` if you are using GitHub.com..

```
Enter GHE Hostname: myserver.ghe-test.ninja
Enter token: ***cc2d128a
```

* If you want a different team name,  you can edit  `.gh-api-examples.conf` with an editor of your choice.


or if you need to go non-interactive values can be specified on the command line in order to use The Power in an automation of some kind:

```
python3 configure.py --hostname gm3dmo-00000000000000000.ghe-test.net \
                     --token ghp_****************************wh3Ybleu \
                     --webhook-url https://events.hookdeck.com/e/src_1hm2RSyiguMW
```

* You are all set to go to the next section.


## Applying a build to the GHE server

```
bash build-all.sh
```
