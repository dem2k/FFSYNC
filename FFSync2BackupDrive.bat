@REM THE FOLDER NAME WHERE BACKUP WILL BE STORED
@SET BACKUP_FOLDER=TRANSCEND64

@REM --- DO NOT CHANGE ANYTHING BELOW THIS LINE ---------------------------

@ECHO OFF
IF NOT "%OS%"=="Windows_NT" EXIT /B
SETLOCAL

FOR %%L IN (V T R Q P O N M K J I W X Y Z L U S H G F E D) DO (
  IF EXIST %%L:\%BACKUP_FOLDER% SET BACKUP_DRIVE=%%L:
)

IF "%BACKUP_DRIVE%" == "" (
 MSG %USERNAME% Folder %BACKUP_FOLDER% not found on any Drive.
 GOTO FINISH
)

SET THIS_DRIVE=%~D0

ECHO.
ECHO                %THIS_DRIVE% --^> %BACKUP_DRIVE%\%BACKUP_FOLDER%
ECHO.

SET BERICHT=
SET /P BERICHT=Bericht per Mail senden (ENTER=Nein, gonst gib 'ja' ein.)? 
ECHO.
SET POWEROFF=
SET /P POWEROFF=Computer nach Abschluss herunterfahren (ENTER=Nein, sonst gib 'ja' ein.)? 

%~DP0FFSYNC\freefilesync.exe %~DP0FFSYNC\batchrun.ffs_batch

IF "%BERICHT%" == "ja" (
	GOTO BERICHT
)

FOR %%I IN ("FFSYNC\batchrun*.log") DO START "" notepad.exe "%%I"

GOTO FINISH

:BERICHT
START %~DP0FFSYNC\freesmtpsrv.exe

PING -n 1 -w 1000 1.1.1.1 >NUL
ECHO.
ECHO -------------------------------------------------------------------------------
FOR %%I IN (%~DP0FFSYNC\batchrun*.log) DO (
  COPY "%%I" ffsync-log.txt
  ECHO Logfile from %%~ni attached | %~dp0ffsync\blat - -to dem@deminator.de -subject "%%~ni" -attach ffsync-log.txt -server localhost -f dem@deminator.de -debug
  ECHO -------------------------------------------------------------------------------
  ECHO.
  PING -n 1 -w 1000 1.1.1.1 >nul
)

%~DP0FFSYNC\pskill.exe freesmtpsrv
GOTO FINISH

:FINISH
IF NOT "%POWEROFF%" == "" (
	shutdown -s -t 60
)
ENDLOCAL
