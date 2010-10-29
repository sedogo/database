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

ECHO Using SQL Server Authentication
SET SQLCMD_PARAM=-U %strUserName% -P %strPassword% -S %strServerName% -d %strDatabaseName% -i

ECHO Creating tables...
echo . >> %logFileName%
ECHO Creating tables... >> %logFileName%

sqlcmd %SQLCMD_PARAM% ..\Tables\createCountryTables.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\Tables\createGlobalDataTables.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\Tables\createUsersTables.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\Tables\createEventsTables.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\Tables\createAdministratorsTables.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\Tables\createAddressBookTables.sql >> %logFileName%

ECHO Creating Stored Procedures...
echo . >> %logFileName%
ECHO Creating Stored Procedures... >> %logFileName%

sqlcmd %SQLCMD_PARAM% ..\StoredProcs\createCountryStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\StoredProcs\createUsersStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\StoredProcs\createGlobalDataStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\StoredProcs\createEventsStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\StoredProcs\createAdministratorsStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\StoredProcs\createMessagesStoredProcs.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\StoredProcs\createAddressBookStoredProcs.sql >> %logFileName%

ECHO Populating tables...
echo . >> %logFileName%
ECHO Populating tables... >> %logFileName%

sqlcmd %SQLCMD_PARAM% ..\populateTables\populateCountries.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\populateTables\populateLanguages.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\populateTables\populateGlobalData.sql >> %logFileName%
sqlcmd %SQLCMD_PARAM% ..\populateTables\populateAdministrators.sql >> %logFileName%

ECHO .

echo . >> %logFileName%
echo . >> %logFileName%

ECHO "Done! Please check the ProgressLog.txt and log files for errors."
ECHO "Done!" >> %logFileName%

notepad.exe %logFileName%

@echo off

rem @echo.

@pause

exit
