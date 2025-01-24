# Using The Power to test webhooks

## Requirements

- Python >=3.9

## Setup
### Setup a webserver with reverse proxy

You'll need an endpoint for your hook to deliver to. I like to use a cheap virtual host and install the [Caddy](https://caddyserver.com/docs/) webserver for it's automated SSL cert management.

### Setup a python virtual environment
Create a python virtual environment called *pwrhook*:
```shell
cd hook-receiver
python -m venv pwrhook
```

Activate the *pwrhook* virtual environment:
```shell
source pwrhook/bin/activate
```

Install piptools and packages in the *pwrhook* virtual environment:
```shell
pip install pip-tools
pip-compile requirements-pwrhook.in
pip install -r requirements-pwrhook.txt
```

## Run the hook receiver script `hooky-secret-validation.py`
The tmux program is useful if this is going to be a long running test.

Activate your virtual environment:

```shell
source pwrhook/bin/activate
```

Start the hook receiver:

```shell
python hook-receiver.py 

```

Or to [validate webhook deliveries](https://docs.github.com/en/enterprise-cloud@latest/webhooks/using-webhooks/validating-webhook-deliveries) using a secret. If the webhook is setup with the power using a secret:

```shell
python hook-receiver.py --secret pwr-repo-webhook-secret

```

Check the `repo_webhook_secret` value in `.gh-api-examples.conf`

The response should look similar to:

```shell

 * Serving Flask app 'hooky-secret-validation'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://localhost:8000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 110-***-***

```

Create an event that triggers the webhook such as creating an issue or commenting an issue on the GitHub User interface or use a script in the power like create-issue-comment.sh:

```shell
./create-issue-comment.sh
```
