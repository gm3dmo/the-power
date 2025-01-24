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
python hook-receiver.py --secret YOUR_HOOK_SECRET

```

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

Create an event that triggers the hook:

```
./create-issue-comment.sh
```



