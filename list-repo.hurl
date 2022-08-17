GET {{ GITHUB_API_BASE_URL }}/repos/{{ org }}/{{ repo }}
Accept: application/vnd.github.v3+json
Authorization: token {{ GITHUB_TOKEN }}

HTTP/2 200
[Captures]
response_body: body
repo_name: jsonpath "$['name']"
