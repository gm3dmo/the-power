## Shamelessly stolen from @wilsonwong1990 and ingested into the power
## Get's the content of a file from a repository and decodes it from base64
## Replace <YOUR-GHES-HOSTNAME> with your GHES hostname

.  ./.gh-api-examples.conf

branches=$(curl -X GET ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/branches -H "Authorization: Token ${GITHUB_TOKEN}")

echo $branches | jq '.[] | {name: .name, commit: .commit}'

echo "What branch are we working with?"
read branch

commit_sha=$(curl -X GET ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/ref/heads/${branch} -H "Authorization: Token ${GITHUB_TOKEN}" | jq -r '.object.sha')
echo ${commit_sha}

tree_sha=$(curl -X GET ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/commits/${commit_sha} -H "Authorization: Token ${GITHUB_TOKEN}" | jq -r '.tree.sha')

echo ${tree_sha}

tree=$(curl -X GET ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/trees/${tree_sha} -H "Authorization: Token ${GITHUB_TOKEN}")

echo $tree | jq

echo "What file are we looking for? Enter the SHA"
read blob_sha

blob=$(curl -X GET ${GITHUB_API_BASE_URL}/repos/${org}/${repo}/git/blobs/${blob_sha} -H "Authorization: Token ${GITHUB_TOKEN}" | jq -r '.content')
echo $blob | base64 -d
