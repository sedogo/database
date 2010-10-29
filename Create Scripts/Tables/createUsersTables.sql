 /*===============================================================
// Filename: createUsersTables.sql
// Date: 12/08/09
// --------------------------------------------------------------
// Description:
//   This file creates the Users table
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 12/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting createUsersTables.sql =='

/*===============================================================
// Table: Users
//=============================================================*/

PRINT 'Creating Users...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'Users')
	BEGIN
		DROP Table Users
	END
GO

CREATE TABLE Users
(
	UserID							int					NOT NULL PRIMARY KEY IDENTITY,
	GUID							nvarchar(50)		NOT NULL,
	
	EmailAddress					nvarchar(200)		NOT NULL,
	FirstName						nvarchar(200)		NULL,
	LastName						nvarchar(200)		NULL,
	Gender							nchar(1)			NOT NULL,

	HomeTown						nvarchar(200)		NULL,
	Birthday						datetime		    NULL,
	ProfilePicFilename				nvarchar(200)		NULL,
	ProfilePicThumbnail				nvarchar(200)		NULL,
	ProfilePicPreview				nvarchar(200)		NULL,
	ProfileText						nvarchar(200)		NULL,
	AvatarNumber					int					NULL,

	Deleted							bit				    NOT NULL,
	DeletedDate						datetime		    NULL,

	CountryID						int				    NOT NULL,
	LanguageID						int				    NOT NULL,
	TimezoneID						int				    NOT NULL,

	LoginEnabled					bit				    NOT NULL,
	UserPassword					nvarchar(200)		NULL,
	FailedLoginCount				int				    NOT NULL,
	PasswordExpiryDate				datetime		    NULL,
	LastLoginDate					datetime		    NULL,
	EnableSendEmails				bit				    NOT NULL,

	CreatedDate						datetime		    NOT NULL,
	CreatedByFullName				nvarchar(200)	    NOT NULL,
	LastUpdatedDate					datetime		    NOT NULL,
	LastUpdatedByFullName			nvarchar(200)	    NOT NULL,
	FacebookUserID					bigint				NULL
)
GO

/*===============================================================
// Table UserLoginHistory
//=============================================================*/

PRINT 'Creating UserLoginHistory...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'UserLoginHistory')
BEGIN
	DROP Table UserLoginHistory
END
GO

CREATE TABLE UserLoginHistory
(
	UserLoginHistoryID		int				NOT NULL PRIMARY KEY IDENTITY,
	UserID					int				NULL,
	LoginStatus				nchar(1)		NOT NULL,
	LoginDate				datetime		NOT NULL,
	Source                  nvarchar(200)   NULL
)
GO

IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'IX_UserLoginHistory_UserID')
    DROP INDEX IX_UserLoginHistory_UserID ON UserLoginHistory
GO

CREATE INDEX IX_UserLoginHistory_UserID
    ON UserLoginHistory ( UserID ); 
GO

/*===============================================================
// Table: Timezones
//=============================================================*/

PRINT 'Creating Timezones...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'Timezones')
	BEGIN
		DROP Table Timezones
	END
GO

CREATE TABLE Timezones
(
	TimezoneID							int					NOT NULL PRIMARY KEY IDENTITY,
	ShortCode			                nvarchar(10)		NOT NULL,
	Description			                nvarchar(200)		NOT NULL,
	GMTOffset							int					NOT NULL
)
GO

PRINT '== Finished createUsersTables.sql =='
  