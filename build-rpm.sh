#!/bin/bash

## get latest code on specified branch
## and extract version info
pushd ~/virtuoso-opensource
VIRT_BRANCH=${VIRT_BRANCH:-"develop/7"}
echo "updating virtuoso branch $VIRT_BRANCH"
git checkout $VIRT_BRANCH
git pull

VIRT_VERSION_MAJ=`grep -o -P 'vos_major,\s+\[[0-9]+\]' configure.in | grep -o -P '[0-9]+'`
VIRT_VERSION_MIN=`grep -o -P 'vos_minor,\s+\[[0-9]+\]' configure.in | grep -o -P '[0-9]+'`
VIRT_VERSION_PATCH=`grep -o -P 'vos_patch,\s+\[[0-9]+\]' configure.in | grep -o -P '[0-9]+'`
VIRT_VERSION_DEV=`grep -o -P 'vos_devel,\s+\[\-[a-z0-9-]+\]\)' configure.in | grep -o -P '\-[a-z0-9]+'`
VIRT_CUR_VERSION="$VIRT_VERSION_MAJ.$VIRT_VERSION_MIN.$VIRT_VERSION_PATCH"
VIRT_RELEASE=`git rev-parse --short HEAD`
VIRTUOSO_VERSION="$VIRT_CUR_VERSION.$VIRT_RELEASE"
echo "starting rpm build of $VIRTUOSO_VERSION"
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
