# export all variable from now on using `set -a` so perl can get at them: 
set -a
. .gh-api-examples.conf

output_file=tmp/long-list-of-repos.txt

perl -e '$n=$ENV{repo_prefix}; print STDERR "Creating $ENV{number_of_repos} repositories in $ENV{org}.\n"; my $date = time(); for (1..$ENV{number_of_repos}) { printf("%s-%05d\n", $ENV{repo_prefix}, $_); }' > ${output_file}

cat $output_file

>&2 echo "run create-many-orgs.sh to have these created on the appliance in ${org}. "
