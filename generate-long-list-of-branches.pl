perl -e '$date = time(); for ("1".."200") { printf "branch-%05d\n",$_; }' >tmp/longlistofbranches.txt

# To do this on filesytem on a checked out repository (mucho faster than api), copy this script into the repository
# comment out the perl line above and uncomment this one:
#perl -e '$date = time(); for ("0".."50000") { print "git branch branch_$_\n"; }' >tmp/longlistofbranches.txt
#
# Run this script: bash generate-long-list-of-branches.pl
# Execute the output created by above: bash tmp/longlistofbranches.txt
# Finally push it to the origin: time git push --all origin
