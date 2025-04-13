#!/bin/bash

# Set JAVA_OPTS
JAVA_OPTS="-server -Xms2g -Xmx2g -Dfile.encoding=UTF-8"

# Get RUN_HOME
CURRENT_DIR=$(pwd)
RUN_HOME=$(dirname "$CURRENT_DIR")
MAIN_CLASS="${main.class}"

MD5_FILE="$RUN_HOME/config/md5.txt"
if [ -f "$MD5_FILE" ]; then
    MD5_VALUE=$(cat "$MD5_FILE")
    JAVA_OPTS="$JAVA_OPTS -Dcode.md5=$MD5_VALUE"
    echo "MD5 value read from file: $MD5_VALUE"
else
    echo "MD5 file not found."
fi

# Check if JAVA_HOME or JRE_HOME is defined
if [ -z "$JRE_HOME" ] && [ -z "$JAVA_HOME" ]; then
    echo "Neither the JAVA_HOME nor the JRE_HOME environment variable is defined"
    echo "At least one of these environment variable is needed to run this program"
    exit 1
fi

# Use JAVA_HOME as JRE_HOME if JRE_HOME is not defined
if [ -z "$JRE_HOME" ]; then
    JRE_HOME="$JAVA_HOME"
fi

# Check if JRE is available
if [ ! -x "$JRE_HOME/bin/java" ]; then
    echo "The JRE_HOME environment variable is not defined correctly"
    echo "This environment variable is needed to run this program"
    exit 1
fi

# Set _RUNJAVA variable
_RUNJAVA="$JRE_HOME/bin/java"

# Add JDK_JAVA_OPTIONS
JDK_JAVA_OPTIONS="$JDK_JAVA_OPTIONS --add-opens=java.base/java.time=ALL-UNNAMED"
JDK_JAVA_OPTIONS="$JDK_JAVA_OPTIONS --add-opens=java.base/java.math=ALL-UNNAMED"
JDK_JAVA_OPTIONS="$JDK_JAVA_OPTIONS --add-opens=java.base/java.lang=ALL-UNNAMED"
JDK_JAVA_OPTIONS="$JDK_JAVA_OPTIONS --add-opens=java.base/java.io=ALL-UNNAMED"
JDK_JAVA_OPTIONS="$JDK_JAVA_OPTIONS --add-opens=java.base/java.util=ALL-UNNAMED"
JDK_JAVA_OPTIONS="$JDK_JAVA_OPTIONS --add-opens=java.base/java.util.concurrent=ALL-UNNAMED"
JDK_JAVA_OPTIONS="$JDK_JAVA_OPTIONS --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED"

# Set SPRING_OPTIONS variable
SPRING_OPTIONS="$SPRING_OPTIONS -Dspring.profiles.active=${run.env}"
SPRING_OPTIONS="$SPRING_OPTIONS -Dspring.config.location=$RUN_HOME/config/"
SPRING_OPTIONS="$SPRING_OPTIONS -Dspring.web.resources.static-locations=file:$RUN_HOME/static/"
SPRING_OPTIONS="$SPRING_OPTIONS -Dlogging.file.path=$RUN_HOME/logs/"

# Output information
echo "Using RUN_HOME:     $RUN_HOME"
echo "Using JRE_HOME:     $JRE_HOME"
echo "Using JAVA_HOME:    $JAVA_HOME"

# Start Java application and run in the background
nohup $_RUNJAVA $JAVA_OPTS $JDK_JAVA_OPTIONS $SPRING_OPTIONS -cp "$RUN_HOME/lib/*" $MAIN_CLASS > /dev/null 2>&1 &
echo $! > $RUN_HOME/application.pid
