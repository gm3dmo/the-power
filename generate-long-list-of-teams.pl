# export all variable from now on using `set -a` so perl can get at them: 
set -a
. .gh-api-examples.conf

output_file=tmp/long-list-of-teams.txt

perl -e 'print STDERR "Creating $ENV{number_of_teams} teams.\n"; my $date = time(); for (1..$ENV{number_of_teams}) { printf("%s-%05d\n", $ENV{team_prefix}, $_); }' > ${output_file}

cat $output_file

>&2 echo "run create-many-teams.sh to have these created on the appliance. "
