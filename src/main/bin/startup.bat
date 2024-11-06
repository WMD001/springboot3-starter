@echo off
set "BIN_FOLDER=%cd%"
cd "%BIN_FOLDER%"
echo Starting search-front...
echo Please check log file in ../log/search-front.log for more information
java -Dspring.config.location=..\config\application.properties -jar search-front.jar -> ..\log\search-front.log