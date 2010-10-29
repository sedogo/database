@echo off
SET strServerName=JABBA
SET strDatabaseName=sedogoDB
SET strUserName=sedogoUser
SET strPassword=sedogo
SET logFileName=c:\temp\createDatabase.txt
SET logFilePath=c:\temp

echo Creating DB in //%strServerName%/%strDatabaseName% ...
echo Creating DB in //%strServerName%/%strDatabaseName% ... > %logFileName%
echo . >> %logFileName%

SET SQLCMD_PARAM=-U %strUserName% -P %strPassword% -S %strServerName% -d %strDatabaseName% -i

ECHO Creating Stored Procedures...
echo . >> %logFileName%
ECHO Creating Stored Procedures... >> %logFileName%

sqlcmd %SQLCMD_PARAM% .\StoredProcs\createCountryStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% .\StoredProcs\createUsersStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% .\StoredProcs\createGlobalDataStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% .\StoredProcs\createEventsStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% .\StoredProcs\createMessagesStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% .\StoredProcs\createHistoryStoredProcedures.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% .\StoredProcs\createAddressBookStoredProcs.sql >> %logFileName%

ECHO .

echo . >> %logFileName%
echo . >> %logFileName%

ECHO "Done! Please check the ProgressLog.txt and log files for errors."
ECHO "Done!" >> %logFileName%

rem notepad.exe %logFileName%

@echo off

rem @echo.

rem @pause

exit
