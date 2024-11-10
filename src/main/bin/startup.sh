#!/bin/bash

JAR_NAME=${package.name}
JAVA_OPTS="-server -Xms2g -Xmx2g -Dfile.encoding=UTF-8 -Dspring.profiles.active=${run.env}"

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

# Get standard environment variables
PRGDIR=`dirname "$PRG"`

# Only set RUN_HOME if not already set
[ -z "$RUN_HOME" ] && RUN_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`

JAVA_OPTS="$JAVA_OPTS -Dspring.config.location=$RUN_HOME/config"
PACKAGE_NAME="$RUN_HOME/lib/$JAR_NAME.jar"

# Make sure prerequisite environment variables are set
if [ -z "$JAVA_HOME" ] && [ -z "$JRE_HOME" ]; then
  if $darwin; then
    # Bugzilla 54390
    if [ -x '/usr/libexec/java_home' ] ; then
      export JAVA_HOME=`/usr/libexec/java_home`
    # Bugzilla 37284 (reviewed).
    elif [ -d "/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home" ]; then
      export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home"
    fi
  else
    JAVA_PATH=`which java 2>/dev/null`
    if [ "x$JAVA_PATH" != "x" ]; then
      JAVA_PATH=`dirname "$JAVA_PATH" 2>/dev/null`
      JRE_HOME=`dirname "$JAVA_PATH" 2>/dev/null`
    fi
    if [ "x$JRE_HOME" = "x" ]; then
      # XXX: Should we try other locations?
      if [ -x /usr/bin/java ]; then
        JRE_HOME=/usr
      fi
    fi
  fi
  if [ -z "$JAVA_HOME" ] && [ -z "$JRE_HOME" ]; then
    echo "Neither the JAVA_HOME nor the JRE_HOME environment variable is defined"
    echo "At least one of these environment variable is needed to run this program"
    exit 1
  fi
fi

if [ -z "$JRE_HOME" ]; then
  # JAVA_HOME_MUST be set
  if [ ! -x "$JAVA_HOME"/bin/java ]; then
    echo "The JAVA_HOME environment variable is not defined correctly"
    echo "JAVA_HOME=$JAVA_HOME"
    echo "This environment variable is needed to run this program"
    echo "NB: JAVA_HOME should point to a JDK not a JRE"
    exit 1
  fi
  JRE_HOME="$JAVA_HOME"
else
  if [ ! -x "$JRE_HOME"/bin/java ]; then
    echo "The JRE_HOME environment variable is not defined correctly"
    echo "JRE_HOME=$JRE_HOME"
    echo "This environment variable is needed to run this program"
    exit 1
  fi
fi

# Set standard commands for invoking Java, if not already set.
if [ -z "$_RUNJAVA" ]; then
  _RUNJAVA="$JRE_HOME"/bin/java
fi
if [ "$os400" != "true" ]; then
  if [ -z "$_RUNJDB" ]; then
    _RUNJDB="$JAVA_HOME"/bin/jdb
  fi
fi

# JAVA_OPTS
JAVA_OPTS="$JAVA_OPTS --add-opens=java.base/java.math=ALL-UNNAMED"
JAVA_OPTS="$JAVA_OPTS --add-opens=java.base/java.time=ALL-UNNAMED"
JAVA_OPTS="$JAVA_OPTS --add-opens=java.base/java.lang=ALL-UNNAMED"
JAVA_OPTS="$JAVA_OPTS --add-opens=java.base/java.io=ALL-UNNAMED"
JAVA_OPTS="$JAVA_OPTS --add-opens=java.base/java.util=ALL-UNNAMED"
JAVA_OPTS="$JAVA_OPTS --add-opens=java.base/java.util.concurrent=ALL-UNNAMED"
JAVA_OPTS="$JAVA_OPTS --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED"


echo "Using RUN_HOME    $RUN_HOME"
echo "Using JRE_HOME    $JRE_HOME"
echo "Using JAVA_HOME   $JAVA_HOME"


eval nohup "\"$_RUNJAVA\"" "$JAVA_OPTS" \
-jar "$PACKAGE_NAME" >> nohup.out 2>&1 &

echo "Application started."