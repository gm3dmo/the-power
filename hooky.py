
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
from flask import Flask
from flask import request

app = Flask(__name__)


@app.route('/webhook', methods=['POST'])
def slurphook():
    if request.method == 'POST':
        print("hook triggered")
        print(request.json)
        print("sleeping")
        time.sleep(2)
        return ('status',200)


if __name__ == '__main__':
     app.config['DEBUG'] = True
     app.run(host='0.0.0.0', port=8080)
