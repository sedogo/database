 /*===============================================================
// Filename: createAdministratorsStoredProcs.sql
// Date: 19/08/09
// --------------------------------------------------------------
// Description:
//   This file creates the administrators stored procedures
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 19/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting createAdministratorsStoredProcs.sql =='
GO

/*===============================================================
// Function: spAddAdministrator
// Description:
//   Add an administrator to the database
//=============================================================*/
PRINT 'Creating spAddAdministrator...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddAdministrator')
	BEGIN
		DROP Procedure spAddAdministrator
	END
GO

CREATE Procedure spAddAdministrator
	@EmailAddress				nvarchar(200),
	@AdministratorName			nvarchar(200),
	@CreatedDate				datetime,
	@CreatedByFullName			nvarchar(200),
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200),
	@AdministratorID			int OUTPUT
AS
BEGIN
	INSERT INTO Administrators
	(
		EmailAddress,
		AdministratorName,
		Deleted,
		LoginEnabled,
		AdministratorPassword,
		FailedLoginCount,
		PasswordExpiryDate,
		LastLoginDate,
		CreatedDate,
		CreatedByFullName,
		LastUpdatedDate,
		LastUpdatedByFullName
	)
	VALUES
	(
		@EmailAddress,
		@AdministratorName,
		0,
		0,		-- LoginEnabled
		'',		-- AdministratorPassword
		0,		-- FailedLoginCount
		NULL,	-- PasswordExpiryDate
		NULL,	-- LastLoginDate
		@CreatedDate,
		@CreatedByFullName,
		@LastUpdatedDate,
		@LastUpdatedByFullName
	)
	
	SET @AdministratorID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectAdministratorDetails
// Description:
//   Gets administrator details
// --------------------------------------------------------------
// Parameters
//	 @AdministratorID			int
//=============================================================*/
PRINT 'Creating spSelectAdministratorDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectAdministratorDetails')
BEGIN
	DROP Procedure spSelectAdministratorDetails
END
GO

CREATE Procedure spSelectAdministratorDetails
	@AdministratorID			int
AS
BEGIN
	SELECT EmailAddress, AdministratorName, Deleted, DeletedDate,
		LoginEnabled, AdministratorPassword, FailedLoginCount, PasswordExpiryDate, LastLoginDate,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Administrators
	WHERE AdministratorID = @AdministratorID
END
GO

/*===============================================================
// Function: spSelectAdministratorList
// Description:
//   Selects the administrator list
//=============================================================*/
PRINT 'Creating spSelectAdministratorList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectAdministratorList')
BEGIN
	DROP Procedure spSelectAdministratorList
END
GO

CREATE Procedure spSelectAdministratorList
AS
BEGIN
	SELECT AdministratorID, EmailAddress, AdministratorName, 
		LoginEnabled, AdministratorPassword, FailedLoginCount, PasswordExpiryDate, LastLoginDate,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Administrators
	WHERE Deleted = 0
	ORDER BY AdministratorName
END
GO

/*===============================================================
// Function: spUpdateAdministrator
// Description:
//   Update administrator details
//=============================================================*/
PRINT 'Creating spUpdateAdministrator...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateAdministrator')
BEGIN
	DROP Procedure spUpdateAdministrator
END
GO

CREATE Procedure spUpdateAdministrator
	@AdministratorID				int,
	@EmailAddress					nvarchar(200),
	@AdministratorName				nvarchar(200),
	@LoginEnabled					bit,
	@LastUpdatedDate				datetime,
	@LastUpdatedByFullName			nvarchar(200)
AS
BEGIN
	UPDATE Administrators
	SET EmailAddress			= @EmailAddress,
		AdministratorName		= @AdministratorName,
		LoginEnabled			= @LoginEnabled,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE AdministratorID = @AdministratorID
END
GO

/*===============================================================
// Function: spDeleteAdministrator
// Description:
//   Delete administrator
//=============================================================*/
PRINT 'Creating spDeleteAdministrator...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteAdministrator')
BEGIN
	DROP Procedure spDeleteAdministrator
END
GO

CREATE Procedure spDeleteAdministrator
	@AdministratorID			int
AS
BEGIN
	UPDATE Administrators
	SET Deleted = 1
	WHERE AdministratorID = @AdministratorID
END
GO

/*===============================================================
// Function: spVerifyAdministratorLogin
// Description:
//   Get administrator details for login purposes
//=============================================================*/

PRINT 'Creating spVerifyAdministratorLogin...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spVerifyAdministratorLogin')
BEGIN
	DROP Procedure spVerifyAdministratorLogin
END
GO

CREATE Procedure spVerifyAdministratorLogin
	@EmailAddress		nvarchar(200)
AS
BEGIN
	SELECT AdministratorID, LoginEnabled, 
		AdministratorPassword, FailedLoginCount, PasswordExpiryDate
	FROM Administrators
	WHERE UPPER(EmailAddress) = UPPER(@EmailAddress)
	AND Deleted = 0
	
END
GO

/*===============================================================
// Function: spSelectAdministratorPassword
// Description:
//   Get administrator password
// --------------------------------------------------------------
// Parameters
//	 @UserID			int
//=============================================================*/
PRINT 'Creating spSelectAdministratorPassword...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectAdministratorPassword')
BEGIN
	DROP Procedure spSelectAdministratorPassword
END
GO

CREATE Procedure spSelectAdministratorPassword
	@AdministratorID		int
AS
BEGIN
	SELECT AdministratorPassword
	FROM Administrators
	WHERE AdministratorID = @AdministratorID
END
GO

/*===============================================================
// Function: spGetAdministratorIDFromEmailAddress
// Description:
//   Get administrator ID from an email address
//=============================================================*/
PRINT 'Creating spGetAdministratorIDFromEmailAddress...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetAdministratorIDFromEmailAddress')
BEGIN
	DROP Procedure spGetAdministratorIDFromEmailAddress
END
GO

CREATE Procedure spGetAdministratorIDFromEmailAddress
	@EmailAddress		nvarchar(200)
AS
BEGIN
	SELECT AdministratorID
	FROM Administrators
	WHERE UPPER(EmailAddress) = UPPER(@EmailAddress)
	AND Deleted = 0
	
END
GO

/*===============================================================
// Function: spUpdateAdministratorPassword
// Description:
//   Update a administrator password
//=============================================================*/
PRINT 'Creating spUpdateAdministratorPassword...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateAdministratorPassword')
BEGIN
	DROP Procedure spUpdateAdministratorPassword
END
GO

CREATE Procedure spUpdateAdministratorPassword
	@AdministratorID			int,
	@AdministratorPassword		nvarchar(50),
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200)
AS
BEGIN
	UPDATE Administrators
	SET AdministratorPassword	= @AdministratorPassword,
		PasswordExpiryDate		= PasswordExpiryDate+90,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE AdministratorID = @AdministratorID
END
GO

/*===============================================================
// Function: spIncrementAdministratorFailedLoginCount
// Description:
//   Increment failed login count
//=============================================================*/
PRINT 'Creating spIncrementAdministratorFailedLoginCount...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spIncrementAdministratorFailedLoginCount')
BEGIN
	DROP Procedure spIncrementAdministratorFailedLoginCount
END
GO

CREATE Procedure spIncrementAdministratorFailedLoginCount
	@AdministratorID					int
AS
BEGIN
	UPDATE Administrators
	SET FailedLoginCount = FailedLoginCount+1
	WHERE AdministratorID = @AdministratorID
END
GO

/*===============================================================
// Function: spResetAdministratorFailedLoginCount
// Description:
//   Increment failed login count
//=============================================================*/
PRINT 'Creating spResetAdministratorFailedLoginCount...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spResetAdministratorFailedLoginCount')
BEGIN
	DROP Procedure spResetAdministratorFailedLoginCount
END
GO

CREATE Procedure spResetAdministratorFailedLoginCount
	@AdministratorID					int
AS
BEGIN
	UPDATE Administrators
	SET FailedLoginCount = 0
	WHERE AdministratorID = @AdministratorID
END
GO

/*===============================================================
// Function: spInsertAdministratorLoginHistory
// Description:
//   Insert a record into the AdministratorLoginHistory table
//=============================================================*/
PRINT 'Creating spInsertAdministratorLoginHistory...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spInsertAdministratorLoginHistory')
BEGIN
	DROP Procedure spInsertAdministratorLoginHistory
END
GO

CREATE Procedure spInsertAdministratorLoginHistory
	@AdministratorID			int,
	@LoginStatus				nchar(1),
	@Source         			nvarchar(50)
AS
BEGIN
	INSERT INTO AdministratorsLoginHistory
	(
		AdministratorID,
		LoginStatus,
		LoginDate,
		Source
	)
	VALUES
	(
		@AdministratorID,
		@LoginStatus,
		getdate(),
		@Source
	)
END
GO

PRINT '== Finished createAdministratorsStoredProcs.sql =='
GO
