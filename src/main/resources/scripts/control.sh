#!/bin/bash

# Time marker for both stderr and stdout
date 1>&2

CMD=$1

function log {
  timestamp=$(date)
  echo "$timestamp: $1"	   #stdout
  echo "$timestamp: $1" 1>&2; #stderr
}

log "Detected CDH_VERSION of [$CDH_VERSION]"

DEFAULT_NORIKRA_HOME=/usr/lib/norikra

export NORIKRA_HOME=${NORIKRA_HOME:-$CDH_NORIKRA_HOME}
export HADOOP_HOME=${HADOOP_HOME:-$CDH_HADOOP_HOME}

# If NORIKRA_HOME is not set, make it the default
export NORIKRA_HOME=${NORIKRA_HOME:-$DEFAULT_NORIKRA_HOME}

ARGS=()
case $CMD in

  (start)
	log "Starting Norikra"
		ARGS+=("start")
		ARGS+=("--port")
		ARGS+=("$PORT")
		ARGS+=("--ui-port")
		ARGS+=("$UI_PORT")
		ARGS+=("--$THREADING")
		ARGS+=("--stats")
		ARGS+=("$STATS_PATH")
		ARGS+=("--log4j-properties-path")
		ARGS+=("$CONF_DIR/log4j.properties")
	;;

  (*)
	log "Don't understand [$CMD]"
	;;

esac
ARGS+=($ADDITIONAL_ARGS)

cmd="$NORIKRA_HOME/bin/jruby -S norikra ${ARGS[@]}"
echo "Running [$cmd]"
exec $cmd