# Using The Power to test webhooks

## Requirements

- Python >=3.9

## Setup

You'll need an endpoint for your hook to deliver to. I like to use a cheap virtual host and install the [Caddy](https://caddyserver.com/docs/) webserver for it's automated SSL cert management.


```shell
python -m venv pwrhook
pip install -r requirements-pwrhook.txt
```

## Running the hook reciever
I like to start this in a tmux session if this is going to be a long running testing session.

Activate your virtual environment:

```shell
source pwrhook/bin/activate
```

Start the hook receiver (remember in production environments you need to take great care of the hook secret and be very careful not to spill it:

```shell
python hooky-secret-validation.py --secret YOUR_HOOK_SECRET
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

Now make an event happen that will create an event that triggers the hook.

```
./create-issue-comment.sh
```
