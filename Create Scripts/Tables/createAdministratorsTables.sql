/*===============================================================
// Filename: createAdministratorsTables.sql
// Date: 19/08/09
// --------------------------------------------------------------
// Description:
//   This file creates the Administrators table
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 19/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting createAdministratorsTables.sql =='

/*===============================================================
// Table: Administrators
//=============================================================*/

PRINT 'Creating Administrators...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'Administrators')
	BEGIN
		DROP Table Administrators
	END
GO

CREATE TABLE Administrators
(
	AdministratorID							int					NOT NULL PRIMARY KEY IDENTITY,
	
	EmailAddress							nvarchar(200)		NOT NULL,
	AdministratorName						nvarchar(200)		NULL,

	Deleted									bit				    NOT NULL,
	DeletedDate								datetime		    NULL,

	LoginEnabled							bit				    NOT NULL,
	AdministratorPassword					nvarchar(200)		NULL,
	FailedLoginCount						int				    NOT NULL,
	PasswordExpiryDate						datetime		    NULL,
	LastLoginDate							datetime		    NULL,

	CreatedDate								datetime		    NOT NULL,
	CreatedByFullName						nvarchar(200)	    NOT NULL,
	LastUpdatedDate							datetime		    NOT NULL,
	LastUpdatedByFullName					nvarchar(200)	    NOT NULL
)
GO

/*===============================================================
// Table AdministratorsLoginHistory
//=============================================================*/

PRINT 'Creating AdministratorsLoginHistory...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'AdministratorsLoginHistory')
BEGIN
	DROP Table AdministratorsLoginHistory
END
GO

CREATE TABLE AdministratorsLoginHistory
(
	AdministratorLoginHistoryID		int				NOT NULL PRIMARY KEY IDENTITY,
	AdministratorID					int				NULL,
	LoginStatus						nchar(1)		NOT NULL,
	LoginDate						datetime		NOT NULL,
	Source                  		nvarchar(200)   NULL
)
GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'IX_AdministratorsLoginHistory_AdministratorID')
    DROP INDEX IX_AdministratorsLoginHistory_AdministratorID ON AdministratorsLoginHistory
GO

CREATE INDEX IX_AdministratorsLoginHistory_AdministratorID
    ON AdministratorsLoginHistory ( AdministratorID ); 
GO

PRINT '== Finished createAdministratorsTables.sql =='
  