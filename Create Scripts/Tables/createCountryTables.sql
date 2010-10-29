 /*===============================================================
// Filename: createCountryTables.sql
// Date: 12/08/09
// --------------------------------------------------------------
// Description:
//   This file creates the Country/Language tables
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 12/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting createCountryTables.sql =='

/*===============================================================
// Table: Countries
//=============================================================*/

PRINT 'Creating Countries...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'Countries')
	BEGIN
		DROP Table Countries
	END
GO

CREATE TABLE Countries
(
	CountryID						int					NOT NULL PRIMARY KEY IDENTITY,
	CountryName						nvarchar(200)		NOT NULL,
	CountryCode						nvarchar(50)		NULL,
	Deleted							bit					NOT NULL,
	DefaultCountry					bit					NOT NULL
)
GO

/*===============================================================
// Table: Languages
//=============================================================*/

PRINT 'Creating Languages...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'Languages')
	BEGIN
		DROP Table Languages
	END
GO

CREATE TABLE Languages
(
	LanguageID						int					NOT NULL PRIMARY KEY IDENTITY,
	LanguageName					nvarchar(200)		NOT NULL,
	LanguageCode					nvarchar(50)		NULL,
	Deleted							bit					NOT NULL,
	DefaultLanguage					bit					NOT NULL
)
GO

PRINT '== Finished createCountryTables.sql =='
  