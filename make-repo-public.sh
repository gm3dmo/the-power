.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/repos/repos#update-a-repository
# PATCH /repos/{owner}/{repo}

# If the script is passed an argument $1 use that as the repository name.
if [ -n "$1" ]
  then
    repo=$1
fi

json_file=tmp/make-repo-public.json

jq -n \
       --arg visibility "public" \
       '{
         visibility: $visibility
       }' > ${json_file}

curl ${curl_custom_flags} \
     -X PATCH \
     -H "X-GitHub-Api-Version: ${github_api_version}" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        "${GITHUB_API_BASE_URL}/repos/${org}/${repo}" --data @${json_file} |
  python3 -c '
import json
import sys

response = json.load(sys.stdin)
if not isinstance(response, dict) or "visibility" not in response:
    print(json.dumps(response, indent=2))
    print("\nVisibility: \033[31mnot reported\033[0m")
    raise SystemExit

properties = list(response.items())
print("{")
for index, (name, value) in enumerate(properties):
    lines = json.dumps({name: value}, indent=2).splitlines()[1:-1]
    if index < len(properties) - 1:
        lines[-1] += ","
    for line in lines:
        if name == "visibility":
            line = f"\033[32m{line}\033[0m"
        print(line)
print("}")

visibility = response["visibility"]
color = "\033[32m" if visibility == "public" else "\033[31m"
status = visibility if isinstance(visibility, str) else json.dumps(visibility)
print(f"\nVisibility: {color}{status}\033[0m")
'
