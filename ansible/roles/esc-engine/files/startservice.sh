#!/bin/bash

# Set the class path
#
echo Options $1 $2 $3
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set default config
#
LOGCONF="-Dlog4j.configuration=log4j-info.properties"
LIBDIR="-Djava.library.path=$DIR/lib"

# Parse options -c -d -l
#
unset DEBUG
unset ENGINE_CONF

while getopts "c:d:l:" OPTION
do
  case $OPTION in
    c) ENGINE_CONF="-configPath $OPTARG";;
    
    d) DEBUG="-Xrunjdwp:transport=dt_socket,address=5004,server=y,suspend="
       if [ "$OPTARG" == "y" ]; then
         DEBUG="${DEBUG}y"
       else
         DEBUG="${DEBUG}n"
       fi;;

    l) if [ "$OPTARG" == "debug" ]; then
         LOGCONF="-Dlog4j.configuration=log4j-debug.properties"
       elif [ "$OPTARG" == "error" ]; then
         LOGCONF="-Dlog4j.configuration=log4j-error.properties"
       elif [ "$OPTARG" == "info" ]; then
         LOGCONF="-Dlog4j.configuration=log4j-info.properties"
       fi;;

    \?) exit 1;;
  esac
done

java $DEBUG $LIBDIR $LOGCONF -cp "$DIR/../lib/*" com.connexience.server.workflow.cloud.CloudWorkflowEngine $ENGINE_CONF &
ENGINE_PID=$!

echo Engine config: $ENGINE_CONF
echo Engine pid: $ENGINE_PID
echo Engine pid file: $PIDFILE
echo Debug options: $DEBUG

if [ "x$PIDFILE" != "x" ] ; then
  echo $ENGINE_PID > $PIDFILE
fi 
