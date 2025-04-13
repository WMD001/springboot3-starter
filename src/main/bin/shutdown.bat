@echo off

REM Get RUN_HOME
set "CURRENT_DIR=%cd%"
set "RUN_HOME=%CURRENT_DIR%"
cd ..
set "RUN_HOME=%cd%"

set MD5_FILE=%RUN_HOME%\config\md5.txt
set PID_FILE=%RUN_HOME%\application.pid
set PID_FILE_SPRING=%RUN_HOME%\bin\application.pid

REM Try to get PID from PID_FILE
if exist "%PID_FILE%" (
    set /p PID=<%PID_FILE%
    if not "%PID%"=="" (
        echo Stopping process with PID: %PID%
        taskkill /PID %PID% /F
        del %PID_FILE%
        exit /b 0
    ) else (
        echo PID file is empty.
    )
) else (
    echo PID file not found. Trying to stop the process by PID_FILE_SPRING: %PID_FILE_SPRING%
)

REM Try to get PID from PID_FILE_SPRING
if exist "%PID_FILE_SPRING%" (
    set /p PID=<%PID_FILE_SPRING%
    if not "%PID%"=="" (
        echo Stopping process with PID: %PID%
        taskkill /PID %PID% /F
        del %PID_FILE_SPRING%
        exit /b 0
    ) else (
        echo PID file is empty.
    )
) else (
    echo PID_FILE_SPRING not found. Trying to stop the process by MD5 value.
)

REM Read MD5 value from ../config/md5.txt file
if exist "%MD5_FILE%" (
    set /p MD5_VALUE=<%MD5_FILE%
    echo MD5 value read from file: %MD5_VALUE%
    REM Find and terminate the process matching the MD5 value
    for /f "tokens=2" %%p in ('tasklist /fi "imagename eq java.exe" /fo csv ^| findstr /i "%MD5_VALUE%"') do (
        set PID=%%p
        if not "%PID%"=="" (
            echo Stopping process with PID: %PID%
            taskkill /PID %PID% /F
        ) else (
            echo No process found with MD5 value: %MD5_VALUE%
        )
    )
) else (
    echo MD5 file not found.
)