
"""
Flask app that will act as a endpoint for a hook. 
"""

import sys
import json
import string
import datetime
import pprint
import requests
from flask import Flask
from flask import request


app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def slurphook():
    if request.method == 'POST':
        b = request.json
        print("======")
        print(type(b))
        print(b.keys())
        print(b['payload'].keys())
        print("======")

        return ('status',200)


if __name__ == '__main__':
     app.config['DEBUG'] = True
     app.run(host='0.0.0.0', port=8080)
