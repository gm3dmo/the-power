.  ./.gh-api-examples.conf

# URL
# CALL

#create a file with dd that is 10mb in size with 1024 byte blocks
dd if=/dev/zero of=10mb.big bs=1024 count=10240

#track the file with LFS
git lfs track *.big

#add the file to the repo
git add 10mb.big

#commit the file
git commit -m "add 10mb file"

#push the file to the remote repo
git push origin main

#push the lfs object
git lfs push origin main


