"""
A simple Flask app that will act as a endpoint for a hook.

Create a venv:

    python -m venv hooktest
    source hooktest/bin/activate

    python hooky.py

"""


import os
import argparse
import sys
import json
import string
import time
from flask import Flask, request
import hashlib
import hmac
#from werkzeug.exceptions import HTTPException  # Import HTTPException


def verify_signature(payload_body, secret_token, signature_header):
    """
    https://docs.github.com/en/webhooks/using-webhooks/validating-webhook-deliveries

    Verify that the payload was sent from GitHub by validating SHA256.

    Raise and return 403 if not authorized.

    Args:
        payload_body: original request body to verify (request.body())
        secret_token: GitHub app webhook token (WEBHOOK_SECRET)
        signature_header: header received from GitHub (x-hub-signature-256)
    """
    if not signature_header:
        raise HTTPException(status_code=403, detail="x-hub-signature-256 header is missing!")
    hash_object = hmac.new(secret_token.encode('utf-8'), msg=payload_body, digestmod=hashlib.sha256)
    expected_signature = "sha256=" + hash_object.hexdigest()
    if not hmac.compare_digest(expected_signature, signature_header):
        raise HTTPException(status_code=403, detail="Request signature didn't match signature on record")
    else:
        app.logger.debug("-" * 21)
        app.logger.debug("the webhook signature matches")
        app.logger.debug("-" * 21)


app = Flask(__name__)


@app.route('/webhook', methods=['POST'])
def slurphook():
    if request.method == 'POST':
        app.logger.debug("hook triggered")
        app.logger.debug("-" * 21)
        app.logger.debug(f"X-Hub-Signature-256: {request.headers.get('X-Hub-Signature-256')}")
        signature_header = request.headers.get('X-Hub-Signature-256')
        app.logger.debug("-" * 21)
        app.logger.debug(f"Headers: {request.headers}")
        app.logger.debug("-" * 21)
        app.logger.debug(f"JSON payload:\n\n{json.dumps(request.json, indent=4)}")
        verify_signature(request.data, args.hook_secret, signature_header)
        return ('status', 200)


if __name__ == '__main__':

    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--secret",
        action="store",
        dest="hook_secret",
        default=None,
        help="The secret for the webhook",
    )

    args = parser.parse_args()

    app.config['DEBUG'] = True
    app.run(host='localhost', port=8000)
