#!/bin/bash

test $# -eq 2 || { echo -e "\nRun this script with two arguments:\n\nFirst argument: directory of git repo with debian package to build\nSecond argument: 'stable' or 'testing' apt repo"; exit 1; }

cd $1 && cd ${1::-4}
dpkg-buildpackage -uc -us
cd ..

case $2 in
    stable)
        echo "Adding package $1 to urbit-on-arm repo"
        aptly repo add urbit-on-arm ${1::-4}_*_all.deb && aptly publish update -gpg-key="D8BFD6CAB150BD4D70182889CA3F0795A3083046" buster s3:urbit-on-arm:
        ;;
    testing)
        echo "Adding package $1 to urbit-on-arm-testing repo"
        aptly repo add urbit-on-arm-testing ${1::-4}_*_all.deb && aptly publish update -gpg-key="D8BFD6CAB150BD4D70182889CA3F0795A3083046" buster s3:urbit-on-arm-testing:
        ;;
esac

git clean -df
