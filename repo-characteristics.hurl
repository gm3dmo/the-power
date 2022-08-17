GET {{ GITHUB_API_BASE_URL }}/repos/{{ org }}/{{ repo }}
Accept: application/vnd.github.v3+json
Authorization: token {{ GITHUB_TOKEN }}

HTTP/2 200

[Asserts]
status >= 200
status < 300
header "Content-Type" == "application/json; charset=utf-8"
header "x-github-request-id" isString
jsonpath "$.name" == "{{ repo }}"
jsonpath "$.full_name" == "{{ org}}/{{ repo }}"

