.  ./.gh-api-examples.conf

# https://docs.github.com/en/repositories/working-with-files/managing-large-files/configuring-git-large-file-storage
# 

lfs_extension="psd"
lfs_f="10mb"
lfs_filename="${lfs_f}.${lfs_extension}"
lfs_path_filename="src/${repo}/${lfs_f}.${lfs_extension}"

# Use dd to create a file that is 10mb in size with 1024 byte blocks
dd if=/dev/random of=${lfs_path_filename}  bs=1024 count=10240

cd src/${repo}

#track the file with LFS
git lfs track "*.${lfs_extension}"
read x

#add the file to the repo
git add ${lfs_filename}
read x

#commit the file
git commit -m "add 10mb file ${lfs_filename}"
read x

#push the file to the remote repo
git push origin main
read x

echo wait
read x 
#push the lfs object
git lfs push origin main
read x

