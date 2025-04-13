#!/bin/bash

# Get RUN_HOME
CURRENT_DIR=$(pwd)
RUN_HOME=$(dirname "$CURRENT_DIR")

MD5_FILE="$RUN_HOME/config/md5.txt"
PID_FILE="$RUN_HOME/application.pid"
PID_FILE_SPRING="$RUN_HOME/bin/application.pid"

# Try to get PID from PID_FILE
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if [ -n "$PID" ]; then
        echo "Stopping process with PID: $PID"
        kill -15 $PID
        rm "$PID_FILE"
        exit 0
    else
        echo "PID file is empty."
    fi
else
    echo "PID file not found. Trying to stop the process by PID_FILE_SPRING: $PID_FILE_SPRING"
fi

# Try to get PID from PID_FILE_SPRING
if [ -f "$PID_FILE_SPRING" ]; then
    PID=$(cat "$PID_FILE_SPRING")
    if [ -n "$PID" ]; then
        echo "Stopping process with PID: $PID"
        kill -15 $PID
        rm "$PID_FILE_SPRING"
        exit 0
    else
        echo "PID file is empty."
    fi
else
    echo "PID_FILE_SPRING not found. Trying to stop the process by MD5 value."
fi

# Read MD5 value from ../config/md5.txt file
if [ -f "$MD5_FILE" ]; then
    MD5_VALUE=$(cat "$MD5_FILE")
    echo "MD5 value read from file: $MD5_VALUE"
    # Find and terminate the process matching the MD5 value
    PID=$(pgrep -f "$MD5_VALUE")
    if [ -n "$PID" ]; then
        echo "Stopping process with PID: $PID"
        kill -15 $PID
    else
        echo "No process found with MD5 value: $MD5_VALUE"
    fi
else
    echo "MD5 file not found."
fi