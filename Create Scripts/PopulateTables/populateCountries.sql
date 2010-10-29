/*===============================================================
// Filename: populateCountries.sql
// Date: 18/02/06
// --------------------------------------------------------------
// Description:
//   This file populates the Countries table
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 12/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting populateCountries.sql =='

PRINT 'Truncating Countries tables...'

TRUNCATE TABLE Countries
GO

PRINT 'Populating Countries tables...'

DECLARE @CountryID int

EXECUTE spAddCountry
	@CountryName				= 'United Kingdom',
	@CountryCode				= 'UK',
	@DefaultCountry				= true,
	@CountryID					= @CountryID OUT
GO

PRINT '== Finished populateCountries.sql =='
   