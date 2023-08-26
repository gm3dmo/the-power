
count=1500000

dd if=/dev/random of=test-data/release-asset.tar.gz bs=1024 count=${count}
