/*===============================================================
// Filename: populateAdministrators.sql
// Date: 19/08/09
// --------------------------------------------------------------
// Description:
//   This file populates the administrators table
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 19/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting populateAdministrators.sql =='

PRINT 'Truncating Administrators tables...'

TRUNCATE TABLE Administrators
GO

PRINT 'Populating Administrators tables...'

DECLARE @NewAdministratorID int

DECLARE @todaysDate datetime;
SET @todaysDate = getdate();

EXECUTE spAddAdministrator
	@EmailAddress				= 'admin@axinteractive.com',
	@AdministratorName			= 'AXi Administrator',
	@CreatedDate				= @todaysDate,
	@CreatedByFullName			= 'Install',
	@LastUpdatedDate			= @todaysDate,
	@LastUpdatedByFullName		= 'Install',
	@AdministratorID			= @NewAdministratorID OUT

EXECUTE spUpdateAdministrator
	@AdministratorID			= @NewAdministratorID,
	@EmailAddress				= 'admin@axinteractive.com',
	@AdministratorName			= 'AXi Administrator',
	@LoginEnabled				= 1,
	@LastUpdatedDate			= @todaysDate,
	@LastUpdatedByFullName		= 'Install'

EXECUTE spUpdateAdministratorPassword
	@AdministratorID			= @NewAdministratorID,
	@AdministratorPassword		= '4gEGXQVUZSYVwyDACh1byO3KRp1ywnkOJBUtDB4rYYk=',
	@LastUpdatedDate			= @todaysDate,
	@LastUpdatedByFullName		= 'Install'
	
GO

PRINT '== Finished populateAdministrators.sql =='
   