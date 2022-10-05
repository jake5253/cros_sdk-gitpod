#!/bin/bash

FIRST=$(grep -n -m1 'src/third_party/kernel' .repo/manifests/snapshot.xml | cut -d: -f1)
COUNT=$(wc -l .repo/manifests/snapshot.xml | cut -d' ' -f1)
KEEP=$(grep 'src/third_party/kernel/v5.15' .repo/manifests/snapshot.xml)
for l in $(grep -n 'src/third_party/kernel' .repo/manifests/snapshot.xml | cut -d: -f1); do LAST=$l; done
head -n $(( $FIRST - 1 )) .repo/manifests/snapshot.xml > /tmp/mani.fest
echo "$KEEP" >> /tmp/mani.fest
LINESAFTER=$(( $COUNT - $LAST ))
tail -n $(( $LINESAFTER - 2 )) .repo/manifests/snapshot.xml >> /tmp/mani.fest
