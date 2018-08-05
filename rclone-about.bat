REM Get quota information from the remote
REM - Total: total size available
REM - Used: total size used
REM - Free: total amount this user could upload
@ECHO OFF

REM Configuration variables
SET RCLONE_EXE_PATH="%~dp0rclone.exe"
SET RCLONE_CONFIG_PATH="%~dp0rclone.conf"
SET RCLONE_REMOTE_PATH=pCloudEncrypted:

REM Console height / width
MODE 50,10| ECHO off
REM Console title
TITLE rclone-about

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
ECHO ^> About :
ECHO.

SETLOCAL
	SET RCLONE_CONFIG_PASS=%RCLONE_CONFIG_PASSWORD%

	ECHO %RCLONE_REMOTE_PATH% quota information :
	ECHO.

	REM Display %RCLONE_REMOTE_PATH% quota information
	%RCLONE_EXE_PATH% about %RCLONE_REMOTE_PATH% --config=%RCLONE_CONFIG_PATH%
ENDLOCAL

REM Wait 10 seconds, then exit script
TIMEOUT 10 | ECHO off