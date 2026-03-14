
.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/repos#create-or-update-file-contents
# PUT /repos/:owner/:repo/contents/:path
#
# This script commits a Python file containing 7 insecure coding practices
# that will trigger GitHub code scanning (CodeQL) alerts.

# If the script is passed an argument $1 use that as the repo name
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

content=$(cat <<'PYEOF' | python3 base64encode.py
from flask import Flask, request
import os
import sqlite3
import pickle
import subprocess

app = Flask(__name__)


# 1. SQL Injection (py/sql-injection)
@app.route("/user")
def get_user():
    username = request.args.get("username")
    conn = sqlite3.connect("users.db")
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE username = '" + username + "'")
    return str(cursor.fetchall())


# 2. Command Injection (py/command-line-injection)
@app.route("/ping")
def ping():
    hostname = request.args.get("hostname")
    os.system("ping -c 1 " + hostname)
    return "Done"


# 3. Code Injection via eval (py/code-injection)
@app.route("/calc")
def calc():
    expr = request.args.get("expression")
    result = eval(expr)
    return str(result)


# 4. Path Traversal (py/path-injection)
@app.route("/read")
def read_file():
    filename = request.args.get("filename")
    with open("/data/" + filename, "r") as f:
        return f.read()


# 5. Unsafe Deserialization (py/unsafe-deserialization)
@app.route("/load")
def load_data():
    data = request.args.get("data")
    obj = pickle.loads(data.encode())
    return str(obj)


# 6. Reflected XSS (py/reflective-xss)
@app.route("/greet")
def greet():
    name = request.args.get("name")
    return "<h1>Hello " + name + "</h1>"


# 7. Command Injection via subprocess shell=True (py/command-line-injection)
@app.route("/run")
def run_command():
    cmd = request.args.get("cmd")
    result = subprocess.check_output(cmd, shell=True)
    return result


if __name__ == "__main__":
    app.run(debug=True)
PYEOF
)

target_file=bad-practice.py
json_file=tmp/create-commit-bad-practice.json

# Get the sha of the existing file if it exists
existing_sha=$(curl -s \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${target_file} | jq -r '.sha // empty')

if [ -n "${existing_sha}" ]; then
    jq -n \
        --arg message  "Updating ${target_file}" \
        --arg name     "${default_committer}" \
        --arg email    "noreply+${default_committer}@example.com" \
        --arg content  "${content}" \
        --arg sha      "${existing_sha}" \
        '{
           "message": $message,
           "committer": {
             "name": $name,
             "email": $email
           },
           "content": $content,
           "sha": $sha
         }' > ${json_file}
else
    jq -n \
        --arg message  "Adding ${target_file}" \
        --arg name     "${default_committer}" \
        --arg email    "noreply+${default_committer}@example.com" \
        --arg content  "${content}" \
        '{
           "message": $message,
           "committer": {
             "name": $name,
             "email": $email
           },
           "content": $content
         }' > ${json_file}
fi

curl ${curl_custom_flags} \
     -X PUT \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/contents/${target_file} --data @${json_file}
