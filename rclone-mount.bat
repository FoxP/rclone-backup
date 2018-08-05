REM Mount a remote as a mountpoint
REM To run rclone mount, you need WinFsp (FUSE for Windows)
REM Windows File System Proxy : http://www.secfs.net/winfsp/
REM The mountpoint must be an unused drive letter
@ECHO OFF

REM Configuration variables
SET RCLONE_EXE_PATH="%~dp0rclone.exe"
SET RCLONE_CONFIG_PATH="%~dp0rclone.conf"
REM Paths
SET RCLONE_REMOTE_PATH=pCloudEncrypted:
SET RCLONE_LOCAL_DRIVE=X:
REM Buffer size when copying files (default 16M)
SET RCLONE_BUFFER_SIZE=64M
REM IO idle timeout (default 5m0s)
SET RCLONE_IO_IDLE_TIMEOUT=5s
REM Connect timeout (default 1m0s)
SET RCLONE_CONNECT_TIMEOUT=5s
REM Number of low level retries to do (default 10)
SET RCLONE_LOW_LEVEL_RETRIES_NUMBER=10
REM Retry operations this many times if they fail (default 3)
SET RCLONE_RETRIES_NUMBER=10
REM Interval between retrying operations if they fail, e.g 500ms, 60s, 5m (0 to disable)
SET RCLONE_RETRIES_SLEEP=0
REM Additional rclone flags
SET RCLONE_ADDITIONAL_FLAGS=--read-only

REM Console height / width
MODE 50,10| ECHO off
REM Console title
TITLE rclone-mount

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
ECHO ^> Mount :
ECHO.

SETLOCAL
	set RCLONE_CONFIG_PASS=%RCLONE_CONFIG_PASSWORD%

	ECHO %RCLONE_REMOTE_PATH% mounted on %RCLONE_LOCAL_DRIVE%
	ECHO.

	REM Mount %RCLONE_REMOTE_PATH% on %RCLONE_LOCAL_DRIVE% drive letter
	%RCLONE_EXE_PATH% mount %RCLONE_REMOTE_PATH% %RCLONE_LOCAL_DRIVE% --config=%RCLONE_CONFIG_PATH% %RCLONE_ADDITIONAL_FLAGS% --buffer-size %RCLONE_BUFFER_SIZE% --timeout %RCLONE_IO_IDLE_TIMEOUT% --contimeout %RCLONE_CONNECT_TIMEOUT% --low-level-retries %RCLONE_LOW_LEVEL_RETRIES_NUMBER% --retries %RCLONE_RETRIES_NUMBER% --retries-sleep %RCLONE_RETRIES_SLEEP%
ENDLOCAL
REM Wait 10 seconds, then exit script
TIMEOUT 10 | ECHO off