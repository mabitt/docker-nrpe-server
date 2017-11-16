#!/bin/sh

#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

PROGNAME=`basename $0`
VERSION="Version 0.1.0,"
AUTHOR="MAB@MAB.NET"


ST_OK=0
ST_WR=1
ST_CR=2
ST_UK=3


print_version() {
    echo "$VERSION $AUTHOR"
}

print_help() {
    print_version $PROGNAME $VERSION
        echo ""
    echo "$PROGNAME is a Nagios plugin to check ."
    echo ""
    exit $ST_UK
}

while test -n "$1"; do
    case "$1" in
        -help|-h)
            print_help
            exit $ST_UK
            ;;
        --version|-v)
            print_version $PROGNAME $VERSION
            exit $ST_UK
            ;;
        --name)
            CONTNAME=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit $ST_UK
            ;;
    esac
    shift
done

get_args() {
    if [ -z "${CONTNAME}"  -o -z "${CONTWARN}"  -o -z "${CONTCRIT}" ]
    then
        echo "Please adjust your name/warn/crit value!"
        exit $ST_UK
    fi
    if [ "${CONTWARN}" -lt "${CONTCRIT}" ]
    then
        echo "warn value must be greater than or equal to crit value!"
        exit $ST_UK
    fi

}

get_docker() {
    NUMREPL=`docker service inspect ${CONTNAME} --format "{{.Spec.Mode.Replicated.Replicas}}"`
    NUMCONT=`docker service ps --format "{{.Name}}: {{.CurrentState}}" ${CONTNAME} --filter "desired-state=running" | grep Running | wc -l`
}

# Here we go!
get_args
get_docker

NUMCRIT=$((${NUMREPL}/2))

if [ "${NUMCONT}" -lt  "${NUMCRIT}" ] ;  then
    echo "CRITICAL - ${CONTNAME} have ${NUMCONT} replicas running of ${NUMREPL}"
    exit $ST_CR
elif [ "${NUMCONT}" -lt  "${NUMREPL}" ] ;  then
    echo "WARNING - ${CONTNAME} have ${NUMCONT} replicas running of ${NUMREPL}"
    exit $ST_WR
else
    echo "OK - ${CONTNAME} have ${NUMCONT} replicas running of ${NUMREPL}"
    exit $ST_OK
fi
