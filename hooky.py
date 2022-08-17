
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

@app.route('/', methods=['POST'])
def slurphook():
    if request.method == 'POST':
        b = request.json
        print("======")
        print(type(b))
        print(b.keys())
        print(b['payload'].keys())
        print(b['payload']['commits'])
        print("======")

        wanted_ref='refs/heads/main'
        watched_file = 'docs/README.md'

        status = {}
        status['wanted_file'] = 'unchanged'
        status['wanted_file_name'] = watched_file
        for commit in b['payload']['commits']:
            print("commit:",commit)
            if watched_file in commit['added']:
               print("File was added!", watched_file)
               print(commit)
            elif watched_file in commit['modified']:
               print("File was modified!", watched_file)
               print(commit)
            elif watched_file in commit['removed']:
               print("File was modified!", watched_file)
               print(commit)
        return ('status',200)


if __name__ == '__main__':
     app.config['DEBUG'] = True
     app.run(host='0.0.0.0', port=8080)
