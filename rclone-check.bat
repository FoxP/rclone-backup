REM Make source and dest identical, modifying destination only
REM Destination is updated to match source, including deleting files if necessary
REM If dest:path doesn’t exist, it is created and the source:path contents go there
REM Doesn’t transfer unchanged files, testing by size and modification time or MD5SUM
@ECHO OFF

REM Configuration variables
SET RCLONE_EXE_PATH="%~dp0rclone.exe"
SET RCLONE_CONFIG_PATH="%~dp0rclone.conf"
SET RCLONE_LOG_FILE_PATH="%~dp0rclone-check-log.txt"
REM Log level : DEBUG|INFO|NOTICE|ERROR (default NOTICE)
SET RCLONE_LOG_LEVEL=NOTICE
REM Read exclude patterns from file
SET RCLONE_FILTER_FILE_PATH="%~dp0rclone-filters.txt"
REM Number of checkers to run in parallel (default 8)
SET RCLONE_CHECKERS_NUMBER=8
REM Number of file transfers to run in parallel (default 4)
SET RCLONE_FILE_TRANSFERS_NUMBER=4
REM Number of low level retries to do (default 10)
SET RCLONE_LOW_LEVEL_RETRIES_NUMBER=10
REM Retry operations this many times if they fail (default 3)
SET RCLONE_RETRIES_NUMBER=10
REM Interval between retrying operations if they fail, e.g 500ms, 60s, 5m (0 to disable)
SET RCLONE_RETRIES_SLEEP=5s
REM Paths
SET RCLONE_LOCAL_PATH=D:\
SET RCLONE_REMOTE_PATH=pCloudEncrypted:
REM Local directory names to sync, comma separated
SET RCLONE_DIRECTORIES_TO_SYNC=Backups,Documents,Ebooks,Games,Movies,Music,Pictures,Softwares
REM Additional rclone flags
SET RCLONE_ADDITIONAL_FLAGS=--delete-excluded

REM Console height / width
MODE 50,20 | ECHO off
REM Console title
TITLE rclone-check

ECHO.
REM If password is not passed as argument
IF [%1] == [] (
	REM Ask for rclone config password
	SET /p RCLONE_CONFIG_PASSWORD="> Config password : "
) ELSE (
	SET RCLONE_CONFIG_PASSWORD=%1
)

CLS

ECHO.
ECHO ^> Check :
ECHO.

SETLOCAL
	SET RCLONE_CONFIG_PASS=%RCLONE_CONFIG_PASSWORD%
	
	FOR %%A IN (%RCLONE_DIRECTORIES_TO_SYNC%) DO (
		ECHO  - %RCLONE_LOCAL_PATH%%%A -^> %RCLONE_REMOTE_PATH%%%A
		@ECHO %date%;%time%;%%A;start>> %RCLONE_LOG_FILE_PATH%
		%RCLONE_EXE_PATH% cryptcheck "%RCLONE_LOCAL_PATH%%%A" "%RCLONE_REMOTE_PATH%%%A" --config=%RCLONE_CONFIG_PATH% --exclude-from=%RCLONE_FILTER_FILE_PATH% %RCLONE_ADDITIONAL_FLAGS% --log-file=%RCLONE_LOG_FILE_PATH% --log-level %RCLONE_LOG_LEVEL% --transfers=%RCLONE_FILE_TRANSFERS_NUMBER% --checkers %RCLONE_CHECKERS_NUMBER% --low-level-retries %RCLONE_LOW_LEVEL_RETRIES_NUMBER% --retries %RCLONE_RETRIES_NUMBER% --retries-sleep %RCLONE_RETRIES_SLEEP%
		@ECHO %date%;%time%;%%A;end>> %RCLONE_LOG_FILE_PATH%
	)
ENDLOCAL

REM Wait 10 seconds, then exit script
TIMEOUT 10 | ECHO off