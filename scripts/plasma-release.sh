#!/bin/bash
#
# add/remove Plasma release recipes
#

function usage()
{
    echo "$1 [add|remove] <version>"
    exit 1
}

command=$1
if [ -z "$command" ]; then usage $0; fi

version=$2
if [ -z "$version" ]; then usage $0; fi

base=`dirname $0`/../recipes-plasma

case $command in
add)
    for recipe in `find $base -name "*.inc" | grep -v /staging/`; do
        name=`echo $recipe | sed -e "s,\.inc,_${version}.bb,"`
        echo -e 'require ${PN}.inc\nSRCREV = "v${PV}"' > $name
        git add $name
    done
    ;;
remove)
    for recipe in `find $base -name "*_$version.bb"`; do
        git rm -f $recipe
    done
    ;;
*)
    usage $0
    ;;
esac