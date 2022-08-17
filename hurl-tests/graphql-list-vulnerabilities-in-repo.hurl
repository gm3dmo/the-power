POST {{ GITHUB_APIV4_BASE_URL }}
Accept: application/vnd.github.v3+json
Authorization: token {{ GITHUB_TOKEN }}
{
  "query": "   {\n      repository(owner: \"forest-town\", name: \"test4\") {\n        name\n        vulnerabilityAlerts(first: 10) {\n          nodes {\n                  id\n                  createdAt\n                  vulnerableManifestPath\n                  securityVulnerability {\n                            severity\n                            package {\n                                name\n                            }\n                        }\n                        securityAdvisory {\n                            summary\n                            permalink\n                        }\n          }\n          pageInfo {\n            endCursor\n            startCursor\n          }\n        }\n      }\n    }"
}


HTTP/2 200
[Captures]
response_body: body
