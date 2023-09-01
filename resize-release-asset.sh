
count=1500000

asset_file=test-data/release-asset.gz
bs=1024

dd if=/dev/random of=${asset_file} bs=${bs} count=${count}


echo Asset file is is now:
ls -lh ${asset_file}
