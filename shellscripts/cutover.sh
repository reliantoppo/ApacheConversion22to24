#!/usr/bin/env bash

PID=$(ps -ef | grep -v grep | grep "http" | awk '{print $2}')

# Require -v version for which version of Apache we're cutting over to.
usage() { echo -e "You must specify which version of Apache to cutover to.\n Usage: $0 [-v <22|24>]" 1>&2; exit 1; }

while getopts ":v:" o; do
    case "${o}" in
        v)
            V=${OPTARG}
            ((V == 22 || V == 24)) || usage
            ;;
        *)
            usage
            ;;
    esac
done
shift "$((OPTIND-1))"

if [ -z "${V}" ]; then
    usage
fi

# Stop "current" version of Apache from running; waiting 5 seconds before proceeding.
/web/apache/current/bin/httpd -k stop
sleep 5

# Test to see if any processes are running the httpdaemon, if so exit; otherwise change over the symlink.

if [ $(ps -ef | grep -v grep | grep httpd | wc -l) -ne 0 ]; then
  echo -e "Based off the PIDs running it would seem Apache is still running. Perhaps try running \nkill -9 $PID"
	exit 1
fi

if [ $V = 24 ]; then
  echo "Changing over 'current' symlink to Apache version 2.4.29."
  ln -sfn /web/apache/2.4.29 /web/apache/current
else [ $V = 22 ];
  echo "Changing over 'current' symlink to Apache version 2.2.23."
  ln -sfn /web/apache/2.2.23 /web/apache/current
fi
