/*===============================================================
// Filename: populateLanguages.sql
// Date: 15/10/06
// --------------------------------------------------------------
// Description:
//   This file populates the Languages table
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 12/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting populateLanguages.sql =='

PRINT 'Truncating Languages tables...'

TRUNCATE TABLE Languages
GO

PRINT 'Populating Languages tables...'

DECLARE @LanguageID int

EXECUTE spAddLanguage
	@LanguageName				= 'English (United Kingdom)',
	@LanguageCode				= 'EN-GB',
	@DefaultLanguage			= true,
	@LanguageID					= @LanguageID OUT
GO

PRINT '== Finished populateLanguages.sql =='
    