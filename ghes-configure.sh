# Read in a config file where reused variables can be stored:
. ghes.conf

# When building testcases it can be nice for them to have their own
# repository to live in. If passed an optional argument
if [ -z "$1" ]
  then
    repo=$repo
  else
    repo=$1
fi

python3 configure.py --hostname ${hostname} \
                     --enterprise-name ${enterprise_name} \
                     --org ${org} \
                     --repo ${repo} \
                     --token ${github_token} \
                     --webhook-url ${webhook} \
                     --number-of-orgs 5 \
                     --number-of-repos 3 \
                     --team-members 'mona hubot mario luigi bugsbunny'
