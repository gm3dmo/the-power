. .gh-api-examples.conf

perl -e 'printf "\* \@$ENV{org}/$ENV{secondary_team}\n";$date = time(); for ("1".."10") { printf "a-%05d/ \@$ENV{org}/$ENV{team_slug}\n",$_; }; printf "/docs/README.md \@$ENV{org}/$ENV{team_slug}"' >tmp/CODEOWNERS
