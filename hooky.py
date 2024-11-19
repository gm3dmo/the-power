
"""
A simple Flask app that will act as a endpoint for a hook.

Create a venv:

    python -m venv hooktest
    source hooktest/bin/activate

    python hooky.py

"""

import sys
import json
import string
import time
import logzero
from flask import Flask
from flask import request

app = Flask(__name__)


@app.route('/webhook', methods=['POST'])
def slurphook():
    if request.method == 'POST':
        if request.headers.getlist("X-Forwarded-For"):
            ip = request.headers.getlist("X-Forwarded-For")[0]
        else:
            ip = request.remote_addr
        data = request.json
        keys = list(data.keys())
        first_key = keys[0]
        hook_action = data[first_key]
        hook_target = keys[1]
        print(f"""hook received for target = "{hook_target}" action = "{hook_action}" triggered by ip address: (should be part of https://api.github.com/meta): {ip}""")
        print(f"-----")
        #print(f"{request.json}")
        return ('status',200)


if __name__ == '__main__':
     app.config['DEBUG'] = False
     app.run(host='localhost', port=8000)
