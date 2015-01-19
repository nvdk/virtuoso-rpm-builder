#!/bin/bash

## get latest code on specified branch
## and extract version info
pushd ~/virtuoso-opensource
VIRT_BRANCH=${VIRT_BRANCH:-"develop/7"}
git checkout $VIRT_BRANCH
git pull
VIRT_CUR_VERSION=`grep -o -P '\[([0-9]\.?){3}(-dev)?\]' configure.in | grep -o -P '([0-9]\.?){3}'`
VIRT_RELEASE=`git rev-parse --short HEAD`
VIRTUOSO_VERSION="$VIRT_CUR_VERSION.$VIRT_RELEASE"
popd


## add version info in the RPM spec
VIR_DATE=`date +"%a %b %d %Y"`
sed -i "s/\#\#VERSION\#\#/$VIRTUOSO_VERSION/" ~/SPECS/virtuoso-opensource.spec
sed -i "s/\#\#DATE\#\#/$VIR_DATE/" ~/SPECS/virtuoso-opensource.spec

## create source package
tar czf ~/SOURCES/virtuoso-opensource-$VIRTUOSO_VERSION.tar.gz --exclude '.git' --transform s/virtuoso-opensource/virtuoso-opensource-$VIRTUOSO_VERSION/ -c ~/virtuoso-opensource .

## build rpm and rpms
pushd ~/SPECS
rpmbuild -ba virtuoso-opensource.spec
popd
