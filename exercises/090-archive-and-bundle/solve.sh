export GIT_CONFIG_GLOBAL=/dev/null
cd repo
mkdir -p ../dist ../usb
git archive --format=tar.gz --prefix=brightcart-2.0.0/ -o ../dist/brightcart-2.0.0.tar.gz v2.0.0
git bundle create -q ../usb/brightcart.bundle --all
git bundle verify -q ../usb/brightcart.bundle
git clone -q ../usb/brightcart.bundle ../offsite
git -C ../offsite fsck --no-progress
