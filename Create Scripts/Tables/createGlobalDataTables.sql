 /*===============================================================
// Filename: createGlobalDataTables.sql
// Date: 12/08/09
// --------------------------------------------------------------
// Description:
//   This file creates the GlobalData table
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 12/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting createGlobalDataTables.sql =='

/*===============================================================
// Table: GlobalData
//=============================================================*/

PRINT 'Creating GlobalData...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'GlobalData')
	BEGIN
		DROP Table GlobalData
	END
GO

CREATE TABLE GlobalData
(
	GlobalDataID		int					NOT NULL PRIMARY KEY IDENTITY,
	KeyName				nvarchar(50)		NOT NULL,

	IntegerValue		int					NULL,
	NumericValue		decimal(10,2)		NULL,
	DateValue			datetime			NULL,
	StringValue			nvarchar(1000)		NULL
)
GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'IX_GlobalData_KeyName')
    DROP INDEX IX_GlobalData_KeyName ON GlobalData
GO

CREATE INDEX IX_GlobalData_KeyName 
    ON GlobalData ( KeyName ); 
GO

PRINT '== Finished createGlobalDataTables.sql =='
 