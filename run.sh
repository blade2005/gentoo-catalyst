#!/bin/bash
BASE_DIR=/var/tmp/catalyst/builds/default
test -d $BASE_DIR || mkdir -p $BASE_DIR

curl -q https://gentoo.osuosl.org/releases/amd64/autobuilds/latest-stage3-amd64.txt | \
grep -vE 'Latest|ts' | \
awk '{print $1}' | \
wget -i - -B https://gentoo.osuosl.org/releases/amd64/autobuilds/ -O $BASE_DIR/stage3-amd64-latest.tar.xz

catalyst -s $(date +%Y.%m)

sed -e "s~@REPO_DIR@.*~$(pwd)/portage~g" -e "s~@TIMESTAMP@~$(date +%Y.%m)~g" stage*.spec -i

catalyst -f stage1.spec && \
catalyst -f stage2.spec && \
catalyst -f stage3.spec && \
catalyst -f stage4.spec 

