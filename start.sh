#!/bin/bash

cd ${GITPOD_REPO_ROOT}
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
echo -e 'umask 022\nexport PATH=${GITPOD_REPO_ROOT}/depot_tools:${PATH}' | tee -a ~/.bashrc
. ~/.bashrc
mkdir ${GITPOD_REPO_ROOT}/chromiumos
cd ${GITPOD_REPO_ROOT}/chromiumos
git config --global color.ui true
#repo init -g minilayout -u https://chromium.googlesource.com/chromiumos/manifest.git --repo-url https://chromium.googlesource.com/external/repo.git -b stable -c --depth=1
repo init -u https://chromium.googlesource.com/chromiumos/manifest.git --repo-url https://chromium.googlesource.com/external/repo.git -b stable -c --depth=1
chmod +x ${GITPOD_REPO_ROOT}/less_kernels.sh
bash ${GITPOD_REPO_ROOT}/less_kernels.sh
mv /tmp/mani.fest .repo/manifests/snapshot.xml
echo "Downloading source (NETWORK SECTION)"
echo "This will take a while"
repo sync -n -j$(( $(nproc) + $(( $(nproc) / 2)) ))
echo "Downloading done"
echo "Now we sync the downloaded file to our tree (LOCAL FILES SECTION)"
repo sync -l -j$(( $(nproc) + $(( $(nproc) / 2)) ))
echo "Sync done"
echo "Reclaiming massive space-hog source code packs"
rm -rf ${GITPOD_REPO_ROOT}/chromiumos/.repo/project-objects/*
echo "Now we'll build the chroot -- and enter when complete"
echo "This takes a few minutes"
cros_sdk
