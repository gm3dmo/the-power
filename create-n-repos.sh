.  ./.gh-api-examples.conf

# https://docs.github.com/en/enterprise-cloud@latest/rest/repos/repos?apiVersion=2022-11-28#create-an-organization-repository
# POST /orgs/{org}/repos


timestamp=$(date +%s)

# If the script is passed an argument $1 use that as the number of repos
# to create:
if [ -z "$1" ]
  then
   number_of_repos_to_create=10
  else
   number_of_repos_to_create=$1
fi

# If the script is passed an argument $2 use that as the name prefix
if [ -z "$2" ]
  then
    repo_name_prefix=${repo}-${timestamp}
  else
    repo_name_prefix=${2}-${timestamp}
fi

# If the script is passed an argument $3 use that as the visibility
# create private repos by default.
if [ -z "$3" ]
  then
    private="true"
    visibility="private"
  else
    private="false"
    visibility=${3}
fi


for repo_number in $(seq 1 ${number_of_repos_to_create})
do
   fw=$(printf %05d ${repo_number})
   json_file=tmp/create-n-repo-details.json
   DATA=$(jq -n \
                --arg name "${repo_name_prefix}-${fw}" \
                --arg private "${private}" \
                --arg visibility "${visibility}" \
                '{name : $name, private: $private | test("true"), visibility: $visibility  }' )

   echo ${DATA} > ${json_file}

   curl ${curl_custom_flags} \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
           "${GITHUB_API_BASE_URL}/orgs/${org}/repos" --data @${json_file} | jq -r '"\(.id),\(.full_name)"'
done
