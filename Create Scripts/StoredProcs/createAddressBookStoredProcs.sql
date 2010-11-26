 /*===============================================================
// Filename: createAddressBookStoredProcs.sql
// Date: 26/03/10
// --------------------------------------------------------------
// Description:
//   This file creates the address book stored procedures
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 26/03/10
// Revision history:
//=============================================================*/

PRINT '== Starting createAddressBookStoredProcs.sql =='
GO

/*===============================================================
// Function: spAddAddressBook
// Description:
//   Add a AddressBook
//=============================================================*/
PRINT 'Creating spAddAddressBook...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddAddressBook')
	BEGIN
		DROP Procedure spAddAddressBook
	END
GO

CREATE Procedure spAddAddressBook
	@UserID								int,
	@FirstName			                nvarchar(200),
	@LastName			                nvarchar(200),
	@EmailAddress		                nvarchar(200),
	@AddressBookID						int OUTPUT
AS
BEGIN
	INSERT INTO AddressBook
	(
		UserID,
		FirstName,
		LastName,
		EmailAddress
	)
	VALUES
	(
		@UserID,
		@FirstName,
		@LastName,
		@EmailAddress
	)
	
	SET @AddressBookID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectAddressBookDetails
// Description:
//   Gets AddressBook details
// --------------------------------------------------------------
// Parameters
//	 @UserID			int
//=============================================================*/
PRINT 'Creating spSelectAddressBookDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectAddressBookDetails')
BEGIN
	DROP Procedure spSelectAddressBookDetails
END
GO

CREATE Procedure spSelectAddressBookDetails
	@AddressBookID			int
AS
BEGIN
	SELECT UserID, FirstName, LastName, EmailAddress
	FROM AddressBook
	WHERE AddressBookID = @AddressBookID
END
GO

/*===============================================================
// Function: spSelectAddressBookList
// Description:
//   Selects the AddressBook list
//=============================================================*/
PRINT 'Creating spSelectAddressBookList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectAddressBookList')
BEGIN
	DROP Procedure spSelectAddressBookList
END
GO

CREATE Procedure spSelectAddressBookList
	@UserID		int
AS
BEGIN
	CREATE TABLE #TempAddressBook (
		UserID int, 
		AddressBookID int, 
		FirstName nvarchar(200), 
		LastName nvarchar(200), 
		EmailAddress nvarchar(200),
		ProfilePicThumbnail nvarchar(200),
		AvatarNumber int
	)

	INSERT INTO #TempAddressBook
	(
		UserID, AddressBookID, FirstName, LastName, EmailAddress, 
			ProfilePicThumbnail, AvatarNumber
	)
	SELECT -1 AS UserID, AddressBookID, FirstName, LastName, EmailAddress,
		'', -1
	FROM AddressBook
	WHERE UserID = @UserID
	
	UNION
	
	SELECT DISTINCT(T.UserID) AS UserID, -1 AS AddressBookID, U.FirstName, 
		U.LastName, U.EmailAddress, U.ProfilePicThumbnail, U.AvatarNumber
	FROM Events E
	JOIN TrackedEvents T
	ON E.EventID = T.EventID
	JOIN Users U
	ON U.UserID = T.UserID
	WHERE E.UserID = @UserID
	
	DELETE #TempAddressBook
	WHERE UserID < 0
	AND EmailAddress IN
	(
		SELECT EmailAddress
		FROM #TempAddressBook
		WHERE UserID > 0
	) 
	
	SELECT UserID, AddressBookID, FirstName, LastName, EmailAddress
	FROM #TempAddressBook
	ORDER BY LastName
	
	DROP TABLE #TempAddressBook
END
GO

/*===============================================================
// Function: spUpdateAddressBook
// Description:
//   Update AddressBook details
//=============================================================*/
PRINT 'Creating spUpdateAddressBook...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateAddressBook')
BEGIN
	DROP Procedure spUpdateAddressBook
END
GO

CREATE Procedure spUpdateAddressBook
	@AddressBookID						int,
	@FirstName			                nvarchar(200),
	@LastName			                nvarchar(200),
	@EmailAddress		                nvarchar(200)
AS
BEGIN
	UPDATE AddressBook
	SET FirstName		= @FirstName,
		LastName		= @LastName,
		EmailAddress	= @EmailAddress
	WHERE AddressBookID = @AddressBookID
END
GO

/*===============================================================
// Function: spDeleteAddressBook
// Description:
//   Delete AddressBook details
//=============================================================*/
PRINT 'Creating spDeleteAddressBook...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteAddressBook')
BEGIN
	DROP Procedure spDeleteAddressBook
END
GO

CREATE Procedure spDeleteAddressBook
	@AddressBookID						int
AS
BEGIN
	DELETE AddressBook
	WHERE AddressBookID = @AddressBookID
END
GO

/*===============================================================
// Function: spSelectAddressBookCountByUser
// Description:
//   Selects the AddressBook list
//=============================================================*/
PRINT 'Creating spSelectAddressBookCountByUser...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectAddressBookCountByUser')
BEGIN
	DROP Procedure spSelectAddressBookCountByUser
END
GO

CREATE Procedure spSelectAddressBookCountByUser
	@UserID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM AddressBook
	WHERE UserID = @UserID
END
GO

PRINT '== Finished createAddressBookStoredProcs.sql =='
GO
