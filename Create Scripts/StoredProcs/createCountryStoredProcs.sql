/*===============================================================
// Filename: createCountryStoredProcs.sql
// Date: 12/08/09
// --------------------------------------------------------------
// Description:
//   This file creates the Country/Language stored procedures
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 12/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting createCountryStoredProcs.sql =='
GO

/*===============================================================
// Function: spAddCountry
// Description:
//   Add a country to the database
//=============================================================*/
PRINT 'Creating spAddCountry...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddCountry')
	BEGIN
		DROP Procedure spAddCountry
	END
GO

CREATE Procedure spAddCountry
	@CountryName				nvarchar(200),
	@CountryCode				nvarchar(50),
	@DefaultCountry				bit,
	@CountryID					int OUTPUT
AS
BEGIN
	IF @DefaultCountry = 1
	BEGIN
		UPDATE Countries
		SET DefaultCountry = 0
	END

	INSERT INTO Countries
	(
		CountryName,
		CountryCode,
		Deleted,
		DefaultCountry
	)
	VALUES
	(
		@CountryName,
		@CountryCode,
		0,
		@DefaultCountry
	)
	
	SET @CountryID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectCountryDetails
// Description:
//   Gets country details
// --------------------------------------------------------------
// Parameters
//	 @CountryID			int
//=============================================================*/
PRINT 'Creating spSelectCountryDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectCountryDetails')
BEGIN
	DROP Procedure spSelectCountryDetails
END
GO

CREATE Procedure spSelectCountryDetails
	@CountryID			int
AS
BEGIN
	SELECT CountryName, CountryCode, DefaultCountry
	FROM Countries
	WHERE CountryID = @CountryID
END
GO

/*===============================================================
// Function: spSelectCountryList
// Description:
//   Selects the country list
//=============================================================*/
PRINT 'Creating spSelectCountryList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectCountryList')
BEGIN
	DROP Procedure spSelectCountryList
END
GO

CREATE Procedure spSelectCountryList
AS
BEGIN
	SELECT CountryID, CountryName, CountryCode, DefaultCountry
	FROM Countries
	WHERE Deleted = 0
	ORDER BY CountryName
END
GO

/*===============================================================
// Function: spGetCountryIDFromName
// Description:
//   Get country ID from a country name
// --------------------------------------------------------------
// Parameters
//	 @CountryName			nvarchar(200)
//=============================================================*/
PRINT 'Creating spGetCountryIDFromName...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetCountryIDFromName')
BEGIN
	DROP Procedure spGetCountryIDFromName
END
GO

CREATE Procedure spGetCountryIDFromName
	@CountryName		nvarchar(200)
AS
BEGIN
	SELECT CountryID
	FROM Countries
	WHERE UPPER(CountryName) = UPPER(@CountryName)
	AND Deleted = 0
END
GO

/*===============================================================
// Function: spGetCountryIDFromCode
// Description:
//   Get country ID from a country name
// --------------------------------------------------------------
// Parameters
//	 @CountryCode			nvarchar(50)
//=============================================================*/
PRINT 'Creating spGetCountryIDFromCode...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetCountryIDFromCode')
BEGIN
	DROP Procedure spGetCountryIDFromCode
END
GO

CREATE Procedure spGetCountryIDFromCode
	@CountryCode		nvarchar(50)
AS
BEGIN
	SELECT CountryID
	FROM Countries
	WHERE UPPER(CountryCode) = UPPER(@CountryCode)
	AND Deleted = 0
END
GO

/*===============================================================
// Function: spUpdateCountry
// Description:
//   Update country details
//=============================================================*/
PRINT 'Creating spUpdateCountry...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateCountry')
BEGIN
	DROP Procedure spUpdateCountry
END
GO

CREATE Procedure spUpdateCountry
	@CountryID						int,
	@CountryName					nvarchar(200),
	@CountryCode					nvarchar(50),
	@DefaultCountry					bit
AS
BEGIN
	IF @DefaultCountry = 1
	BEGIN
		UPDATE Countries
		SET DefaultCountry = 0
	END

	UPDATE Countries
	SET CountryName			= @CountryName,
		CountryCode			= @CountryCode,
		DefaultCountry		= @DefaultCountry
	WHERE CountryID = @CountryID
END
GO

/*===============================================================
// Function: spDeleteCountry
// Description:
//   Delete country
//=============================================================*/
PRINT 'Creating spDeleteCountry...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteCountry')
BEGIN
	DROP Procedure spDeleteCountry
END
GO

CREATE Procedure spDeleteCountry
	@CountryID			int
AS
BEGIN
	UPDATE Countries
	SET Deleted = 1
	WHERE CountryID = @CountryID
END
GO

/*===============================================================
// Function: spGetDefaultCountry
// Description:
//   Get default country
// --------------------------------------------------------------
// Parameters
//	 @CountryID			int OUTPUT
//=============================================================*/
PRINT 'Creating spGetDefaultCountry...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetDefaultCountry')
BEGIN
	DROP Procedure spGetDefaultCountry
END
GO

CREATE Procedure spGetDefaultCountry
	@CountryID	int OUTPUT
AS
BEGIN
	SELECT @CountryID = CountryID
	FROM Countries
	WHERE DefaultCountry = 1
END
GO

/*===============================================================
// Function: spAddLanguage
// Description:
//   Add a language to the database
//=============================================================*/
PRINT 'Creating spAddLanguage...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddLanguage')
	BEGIN
		DROP Procedure spAddLanguage
	END
GO

CREATE Procedure spAddLanguage
	@LanguageName				nvarchar(200),
	@LanguageCode				nvarchar(50),
	@DefaultLanguage			bit,
	@LanguageID					int OUTPUT
AS
BEGIN
	IF @DefaultLanguage = 1
	BEGIN
		UPDATE Languages
		SET DefaultLanguage = 0
	END

	INSERT INTO Languages
	(
		LanguageName,
		LanguageCode,
		Deleted,
		DefaultLanguage
	)
	VALUES
	(
		@LanguageName,
		@LanguageCode,
		0,
		@DefaultLanguage
	)
	
	SET @LanguageID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectLanguageDetails
// Description:
//   Gets language details
// --------------------------------------------------------------
// Parameters
//	 @LanguageID			int
//=============================================================*/
PRINT 'Creating spSelectLanguageDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectLanguageDetails')
BEGIN
	DROP Procedure spSelectLanguageDetails
END
GO

CREATE Procedure spSelectLanguageDetails
	@LanguageID			int
AS
BEGIN
	SELECT LanguageName, LanguageCode, DefaultLanguage
	FROM Languages
	WHERE LanguageID = @LanguageID
END
GO

/*===============================================================
// Function: spSelectLanguageList
// Description:
//   Selects the lanaguge list
//=============================================================*/
PRINT 'Creating spSelectLanguageList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectLanguageList')
BEGIN
	DROP Procedure spSelectLanguageList
END
GO

CREATE Procedure spSelectLanguageList
AS
BEGIN
	SELECT LanguageID, LanguageName, LanguageCode, DefaultLanguage
	FROM Languages
	WHERE Deleted = 0
	ORDER BY LanguageName
END
GO

/*===============================================================
// Function: spGetLanguageIDFromName
// Description:
//   Get language ID from a language name
// --------------------------------------------------------------
// Parameters
//	 @LanguageName			nvarchar(200)
//=============================================================*/
PRINT 'Creating spGetLanguageIDFromName...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetLanguageIDFromName')
BEGIN
	DROP Procedure spGetLanguageIDFromName
END
GO

CREATE Procedure spGetLanguageIDFromName
	@LanguageName		nvarchar(200)
AS
BEGIN
	SELECT LanguageID
	FROM Languages
	WHERE UPPER(LanguageName) = UPPER(@LanguageName)
	AND Deleted = 0
END
GO

/*===============================================================
// Function: spGetLanguageIDFromCode
// Description:
//   Get language ID from a language name
// --------------------------------------------------------------
// Parameters
//	 @LanguageCode			nvarchar(50)
//=============================================================*/
PRINT 'Creating spGetLanguageIDFromCode...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetLanguageIDFromCode')
BEGIN
	DROP Procedure spGetLanguageIDFromCode
END
GO

CREATE Procedure spGetLanguageIDFromCode
	@LanguageCode		nvarchar(50)
AS
BEGIN
	SELECT LanguageID
	FROM Languages
	WHERE UPPER(LanguageCode) = UPPER(@LanguageCode)
	AND Deleted = 0
END
GO

/*===============================================================
// Function: spUpdateLanguage
// Description:
//   Update language details
//=============================================================*/
PRINT 'Creating spUpdateLanguage...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateLanguage')
BEGIN
	DROP Procedure spUpdateLanguage
END
GO

CREATE Procedure spUpdateLanguage
	@LanguageID						int,
	@LanguageName					nvarchar(200),
	@LanguageCode					nvarchar(50),
	@DefaultLanguage				bit
AS
BEGIN
	-- If this language is being set to the default, then make sure
	-- all others are not selected
	IF @DefaultLanguage = 1
	BEGIN
		UPDATE Languages
		SET DefaultLanguage = 0
	END

	UPDATE Languages
	SET LanguageName			= @LanguageName,
		LanguageCode			= @LanguageCode,
		DefaultLanguage			= @DefaultLanguage
	WHERE LanguageID = @LanguageID
END
GO

/*===============================================================
// Function: spDeleteLanguage
// Description:
//   Delete language
//=============================================================*/
PRINT 'Creating spDeleteLanguage...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteLanguage')
BEGIN
	DROP Procedure spDeleteLanguage
END
GO

CREATE Procedure spDeleteLanguage
	@LanguageID			int
AS
BEGIN
	UPDATE Languages
	SET Deleted = 1
	WHERE LanguageID = @LanguageID
END
GO

/*===============================================================
// Function: spGetDefaultLanguage
// Description:
//   Get default language
// --------------------------------------------------------------
// Parameters
//	 @LanguageID			int OUTPUT
//=============================================================*/
PRINT 'Creating spGetDefaultLanguage...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetDefaultLanguage')
BEGIN
	DROP Procedure spGetDefaultLanguage
END
GO

CREATE Procedure spGetDefaultLanguage
	@LanguageID	int OUTPUT
AS
BEGIN
	SELECT @LanguageID = LanguageID
	FROM Languages
	WHERE DefaultLanguage = 1
END
GO

PRINT '== Finished createCountryStoredProcs.sql =='
GO
 