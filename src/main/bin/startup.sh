#!/bin/bash



echo "Starting bzj-starter..."
echo "Please execute ./showlog.sh to check log for more information"
nohup java -Dfile.encoding=UTF-8 -Dspring.config.location=../config/application.yml -jar bzj-start.jar > ../log/bzj-start.log 2>&1 &
