@echo off

set JAVA_OPTS=-server -Xms2g -Xmx2g -Dfile.encoding=GBK

rem get RUN_HOME
set "CURRENT_DIR=%cd%"
set "RUN_HOME=%CURRENT_DIR%"
cd ..
set "RUN_HOME=%cd%"
cd "%CURRENT_DIR%"
set "MAIN_CLASS=${main.class}"

rem Otherwise either JRE or JDK are fine
if not "%JRE_HOME%" == "" goto gotJreHome
if not "%JAVA_HOME%" == "" goto gotJavaHome
echo Neither the JAVA_HOME nor the JRE_HOME environment variable is defined
echo At least one of these environment variable is needed to run this program
goto exit


:gotJavaHome
rem No JRE given, use JAVA_HOME as JRE_HOME
set "JRE_HOME=%JAVA_HOME%"

:gotJreHome
rem Check if we have a usable JRE
if not exist "%JRE_HOME%\bin\java.exe" goto noJreHome
goto okJava

:noJreHome
rem Needed at least a JRE
echo The JRE_HOME environment variable is not defined correctly
echo This environment variable is needed to run this program
goto exit


:okJava
rem Set standard command for invoking Java.
rem Also note the quoting as JRE_HOME may contain spaces.
set "_RUNJAVA=%JRE_HOME%\bin\java.exe"

set "JDK_JAVA_OPTIONS=%JDK_JAVA_OPTIONS% --add-opens=java.base/java.time=ALL-UNNAMED"
set "JDK_JAVA_OPTIONS=%JDK_JAVA_OPTIONS% --add-opens=java.base/java.math=ALL-UNNAMED"
set "JDK_JAVA_OPTIONS=%JDK_JAVA_OPTIONS% --add-opens=java.base/java.lang=ALL-UNNAMED"
set "JDK_JAVA_OPTIONS=%JDK_JAVA_OPTIONS% --add-opens=java.base/java.io=ALL-UNNAMED"
set "JDK_JAVA_OPTIONS=%JDK_JAVA_OPTIONS% --add-opens=java.base/java.util=ALL-UNNAMED"
set "JDK_JAVA_OPTIONS=%JDK_JAVA_OPTIONS% --add-opens=java.base/java.util.concurrent=ALL-UNNAMED"
set "JDK_JAVA_OPTIONS=%JDK_JAVA_OPTIONS% --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED"

set "SPRING_OPTIONS=%SPRING_OPTIONS% -Dspring.profiles.active=${run.env}"
set "SPRING_OPTIONS=%SPRING_OPTIONS% -Dspring.config.location=%RUN_HOME%\config\"
set "SPRING_OPTIONS=%SPRING_OPTIONS% -Dspring.web.resources.static-locations=file:%RUN_HOME%\static\"
set "SPRING_OPTIONS=%SPRING_OPTIONS% -Dlogging.file.path=%RUN_HOME%\logs\"

echo Using RUN_HOME:     %RUN_HOME%
echo Using JRE_HOME:     %JRE_HOME%
echo Using JAVA_HOME:    %JAVA_HOME%

%_RUNJAVA% %JAVA_OPTS% %JDK_JAVA_OPTIONS% %SPRING_OPTIONS%  -cp "%RUN_HOME%/lib/*" %MAIN_CLASS%

:exit
exit /b 01