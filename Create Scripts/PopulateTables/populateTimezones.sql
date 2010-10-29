/*===============================================================
// Filename: populateTimezones.sql
// Date: 01/11/09
// --------------------------------------------------------------
// Description:
//   This file populates the timezones table
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 01/11/09
// Revision history:
//=============================================================*/

PRINT '== Starting populateTimezones.sql =='

PRINT 'Populating Timezones tables...'

DECLARE @TimezoneID int

EXECUTE spAddTimezone
	@ShortCode			= 'GMT',
	@Description		= 'GMT',
	@GMTOffset			= 0,
	@TimezoneID			= @TimezoneID OUT

EXECUTE spAddTimezone
	@ShortCode			= 'BST',
	@Description		= 'BST',
	@GMTOffset			= 1,
	@TimezoneID			= @TimezoneID OUT

EXECUTE spAddTimezone
	@ShortCode			= 'EST',
	@Description		= 'EST',
	@GMTOffset			= -5,
	@TimezoneID			= @TimezoneID OUT
GO

PRINT '== Finished populateTimezones.sql =='
    