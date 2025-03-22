# Using The Power to test Webhooks

## Requirements

- Python >=3.9

## Setup
### Setup a webserver with reverse proxy
You'll need an endpoint for your hook to deliver to. [Caddy](https://caddyserver.com/docs/) webserver has automated SSL cert management.

### Setup a python virtual environment
Create a python virtual environment called *pwrhook*:

```shell
cd hookreceiver
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

## Run the hook receiver script `hookreceiver.py`
The tmux program is useful if this is going to be a long running test.

Activate your virtual environment:

```shell
source pwrhook/bin/activate
```

Start the hook receiver:

```shell
python hookreceiver.py 

```

Or to [validate webhook deliveries](https://docs.github.com/en/enterprise-cloud@latest/webhooks/using-webhooks/validating-webhook-deliveries) using a secret. If the webhook is setup with the power using a secret:

```shell
python hookreceiver.py --secret pwr-repo-webhook-secret

```

Check the `repo_webhook_secret` value in `.gh-api-examples.conf` and make sure that matches your secret.

The response should look similar to:

```shell
 * Serving Flask app 'hookreceiver'
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

## Notes on GitHub Documentation
The document [Validating webhook deliveries](https://docs.github.com/en/enterprise-cloud@latest/webhooks/using-webhooks/validating-webhook-deliveries) contains a section titled [Testing the webhook payload validation](https://docs.github.com/en/enterprise-cloud@latest/webhooks/using-webhooks/validating-webhook-deliveries#testing-the-webhook-payload-validation) which explains in prose about the SECRET, PLAIN_PAYLOAD and EXPECTED_SIGNATURE, the  [verify_signature.sh](https://github.com/gm3dmo/the-power/blob/main/hookreceiver/verify_signature.sh) script is a demonstration of this using bash/openssl to derive `CALCULATED_SIGNATURE`:

```
CALCULATED_SIGNATURE=$(echo -n "$PLAIN_PAYLOAD" | openssl dgst -sha256 -hmac "$SECRET" | awk '{print $2}')
```

There are suggestions by AI tools that do this incorrectly.
