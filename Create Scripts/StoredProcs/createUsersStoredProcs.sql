 /*===============================================================
// Filename: createUsersStoredProcs.sql
// Date: 12/08/09
// --------------------------------------------------------------
// Description:
//   This file creates the users stored procedures
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 12/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting createUsersStoredProcs.sql =='
GO

/*===============================================================
// Function: spAddUser
// Description:
//   Add a user to the database
//=============================================================*/
PRINT 'Creating spAddUser...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddUser')
	BEGIN
		DROP Procedure spAddUser
	END
GO

CREATE Procedure spAddUser
	@EmailAddress				nvarchar(200),
	@GUID						nvarchar(50),
	@FirstName					nvarchar(200),
	@LastName					nvarchar(200),
	@Gender						nchar(1),
	@HomeTown					nvarchar(200),
	@Birthday					datetime,
	@CountryID					int,
	@LanguageID					int,
	@TimezoneID					int,
	@ProfileText				nvarchar(200),
	@AvatarNumber				int,
	@CreatedDate				datetime,
	@CreatedByFullName			nvarchar(200),
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200),
	@FacebookUserID				bigint,
	@UserID						int OUTPUT
AS
BEGIN
	INSERT INTO Users
	(
		GUID,
		EmailAddress,
		FirstName,
		LastName,
		Gender,
		HomeTown,
		Birthday,
		Deleted,
		CountryID,
		LanguageID,
		TimezoneID,
		ProfileText,
		LoginEnabled,
		UserPassword,
		FailedLoginCount,
		PasswordExpiryDate,
		LastLoginDate,
		EnableSendEmails,
		AvatarNumber,
		CreatedDate,
		CreatedByFullName,
		LastUpdatedDate,
		LastUpdatedByFullName,		
		FacebookUserID,
		FirstLogin
	)
	VALUES
	(
		@GUID,
		@EmailAddress,
		@FirstName,
		@LastName,
		@Gender,
		@HomeTown,
		@Birthday,
		0,
		@CountryID,
		@LanguageID,
		@TimezoneID,
		@ProfileText,
		0,		-- LoginEnabled
		'',		-- UserPassword
		0,		-- FailedLoginCount
		NULL,	-- PasswordExpiryDate
		NULL,	-- LastLoginDate
		1,		-- EnableSendEmails
		@AvatarNumber,
		@CreatedDate,
		@CreatedByFullName,
		@LastUpdatedDate,
		@LastUpdatedByFullName,		
		@FacebookUserID,
		0		-- FirstLogin
	)
	
	SET @UserID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectUserDetails
// Description:
//   Gets user details
// --------------------------------------------------------------
// Parameters
//	 @UserID			int
//=============================================================*/
PRINT 'Creating spSelectUserDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectUserDetails')
BEGIN
	DROP Procedure spSelectUserDetails
END
GO

CREATE Procedure spSelectUserDetails
	@UserID			int
AS
BEGIN
	SELECT GUID, EmailAddress, FirstName, LastName, Gender, Deleted, DeletedDate,
		HomeTown, Birthday, ProfilePicFilename, ProfilePicThumbnail, ProfilePicPreview,
		ProfileText, CountryID, LanguageID, TimezoneID, EnableSendEmails, AvatarNumber,
		LoginEnabled, UserPassword, FailedLoginCount, PasswordExpiryDate, LastLoginDate,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName, 
		FacebookUserID, FirstLogin
	FROM Users
	WHERE UserID = @UserID
END
GO

/*===============================================================
// Function: spSelectUserList
// Description:
//   Selects the user list
//=============================================================*/
PRINT 'Creating spSelectUserList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectUserList')
BEGIN
	DROP Procedure spSelectUserList
END
GO

CREATE Procedure spSelectUserList
AS
BEGIN
	SELECT UserID, EmailAddress, FirstName, LastName, Gender, CountryID, LanguageID,
		HomeTown, Birthday, ProfileText, TimezoneID, AvatarNumber,
		ProfilePicFilename, ProfilePicThumbnail, ProfilePicPreview, EnableSendEmails,
		LoginEnabled, UserPassword, FailedLoginCount, PasswordExpiryDate, LastLoginDate,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName, FacebookUserID
	FROM Users
	WHERE Deleted = 0
	ORDER BY LastName
END
GO

/*===============================================================
// Function: spUpdateUser
// Description:
//   Update user details
//=============================================================*/
PRINT 'Creating spUpdateUser...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateUser')
BEGIN
	DROP Procedure spUpdateUser
END
GO

CREATE Procedure spUpdateUser
	@UserID							int,
	@EmailAddress					nvarchar(200),
	@FirstName						nvarchar(200),
	@LastName						nvarchar(200),
	@HomeTown						nvarchar(200),
	@Birthday						datetime,
	@Gender							nchar(1),
	@ProfileText					nvarchar(200),
	@CountryID						int,
	@LanguageID						int,
	@TimezoneID						int,
	@LoginEnabled					bit,
	@EnableSendEmails				bit,
	@AvatarNumber					int,
	@LastUpdatedDate				datetime,
	@LastUpdatedByFullName			nvarchar(200),
	@FacebookUserID					bigint
AS
BEGIN
	UPDATE Users
	SET EmailAddress			= @EmailAddress,
		FirstName				= @FirstName,
		LastName				= @LastName,
		HomeTown				= @HomeTown,
		Birthday				= @Birthday,
		Gender					= @Gender,
		CountryID				= @CountryID,
		LanguageID				= @LanguageID,
		TimezoneID				= @TimezoneID,
		ProfileText				= @ProfileText,
		LoginEnabled			= @LoginEnabled,
		EnableSendEmails		= @EnableSendEmails,
		AvatarNumber			= @AvatarNumber,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName,
		FacebookUserID			= @FacebookUserID
	WHERE UserID = @UserID
END
GO

/*===============================================================
// Function: spUpdateUserFirstLogin
// Description:
//   Update user details
//=============================================================*/
PRINT 'Creating spUpdateUserFirstLogin...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateUserFirstLogin')
BEGIN
	DROP Procedure spUpdateUserFirstLogin
END
GO

CREATE Procedure spUpdateUserFirstLogin
	@UserID						int,
	@FirstLogin					bit
AS
BEGIN
	UPDATE Users
	SET FirstLogin			= @FirstLogin
	WHERE UserID = @UserID
END
GO

/*===============================================================
// Function: spUpdateUserProfilePic
// Description:
//   Update user profile picture
//=============================================================*/
PRINT 'Creating spUpdateUserProfilePic...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateUserProfilePic')
BEGIN
	DROP Procedure spUpdateUserProfilePic
END
GO

CREATE Procedure spUpdateUserProfilePic
	@UserID							int,
	@ProfilePicFilename				nvarchar(200),
	@ProfilePicThumbnail			nvarchar(200),
	@ProfilePicPreview				nvarchar(200),
	@LastUpdatedDate				datetime,
	@LastUpdatedByFullName			nvarchar(200)
AS
BEGIN
	UPDATE Users
	SET ProfilePicFilename		= @ProfilePicFilename,
		ProfilePicThumbnail		= @ProfilePicThumbnail,
		ProfilePicPreview		= @ProfilePicPreview,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE UserID = @UserID
END
GO

/*===============================================================
// Function: spDeleteUser
// Description:
//   Delete user
//=============================================================*/
PRINT 'Creating spDeleteUser...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteUser')
BEGIN
	DROP Procedure spDeleteUser
END
GO

CREATE Procedure spDeleteUser
	@UserID			int
AS
BEGIN
	UPDATE Users
	SET Deleted = 1
	WHERE UserID = @UserID
END
GO

/*===============================================================
// Function: spVerifyUserLogin
// Description:
//   Get user details for login purposes
// --------------------------------------------------------------
// Parameters
//	 @UserEmailAddress			nvarchar(200)
//=============================================================*/

PRINT 'Creating spVerifyUserLogin...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spVerifyUserLogin')
BEGIN
	DROP Procedure spVerifyUserLogin
END
GO

CREATE Procedure spVerifyUserLogin
	@EmailAddress		nvarchar(200)
AS
BEGIN
	SELECT UserID, LoginEnabled, 
		UserPassword, FailedLoginCount, PasswordExpiryDate
	FROM Users
	WHERE UPPER(EmailAddress) = UPPER(@EmailAddress)
	AND Deleted = 0
	
END
GO

/*===============================================================
// Function: spSelectUserPassword
// Description:
//   Get user password
// --------------------------------------------------------------
// Parameters
//	 @UserID			int
//=============================================================*/
PRINT 'Creating spSelectUserPassword...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectUserPassword')
BEGIN
	DROP Procedure spSelectUserPassword
END
GO

CREATE Procedure spSelectUserPassword
	@UserID		int
AS
BEGIN
	SELECT UserPassword
	FROM Users
	WHERE UserID = @UserID
END
GO

/*===============================================================
// Function: spGetUserIDFromEmailAddress
// Description:
//   Get user ID from an email address
//=============================================================*/
PRINT 'Creating spGetUserIDFromEmailAddress...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetUserIDFromEmailAddress')
BEGIN
	DROP Procedure spGetUserIDFromEmailAddress
END
GO

CREATE Procedure spGetUserIDFromEmailAddress
	@EmailAddress		nvarchar(200)
AS
BEGIN
	SELECT UserID
	FROM Users
	WHERE UPPER(EmailAddress) = UPPER(@EmailAddress)
	AND Deleted = 0
	
END
GO

/*===============================================================
// Function: spGetUserIDFromGUID
// Description:
//   Get user ID from an email address
//=============================================================*/
PRINT 'Creating spGetUserIDFromGUID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetUserIDFromGUID')
BEGIN
	DROP Procedure spGetUserIDFromGUID
END
GO

CREATE Procedure spGetUserIDFromGUID
	@GUID		nvarchar(50)
AS
BEGIN
	SELECT UserID
	FROM Users
	WHERE UPPER(GUID) = UPPER(@GUID)
	AND Deleted = 0
	
END
GO

/*===============================================================
// Function: spUpdateUserPassword
// Description:
//   Update a users password
//	 @LastUpdatedByFullName		nvarchar(200)
//=============================================================*/
PRINT 'Creating spUpdateUserPassword...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateUserPassword')
BEGIN
	DROP Procedure spUpdateUserPassword
END
GO

CREATE Procedure spUpdateUserPassword
	@UserID						int,
	@UserPassword				nvarchar(50),
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200)
AS
BEGIN
	UPDATE Users
	SET UserPassword			= @UserPassword,
		PasswordExpiryDate		= PasswordExpiryDate+90,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE UserID = @UserID
END
GO

/*===============================================================
// Function: spIncrementFailedLoginCount
// Description:
//   Increment failed login count
//=============================================================*/
PRINT 'Creating spIncrementFailedLoginCount...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spIncrementFailedLoginCount')
BEGIN
	DROP Procedure spIncrementFailedLoginCount
END
GO

CREATE Procedure spIncrementFailedLoginCount
	@UserID					int
AS
BEGIN
	UPDATE Users
	SET FailedLoginCount = FailedLoginCount+1
	WHERE UserID = @UserID
END
GO

/*===============================================================
// Function: spResetFailedLoginCount
// Description:
//   Increment failed login count
//=============================================================*/
PRINT 'Creating spResetFailedLoginCount...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spResetFailedLoginCount')
BEGIN
	DROP Procedure spResetFailedLoginCount
END
GO

CREATE Procedure spResetFailedLoginCount
	@UserID					int
AS
BEGIN
	UPDATE Users
	SET FailedLoginCount = 0
	WHERE UserID = @UserID
END
GO

/*===============================================================
// Function: spInsertUserLoginHistory
// Description:
//   Insert a record into the UserLoginHistory table
//=============================================================*/
PRINT 'Creating spInsertUserLoginHistory...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spInsertUserLoginHistory')
BEGIN
	DROP Procedure spInsertUserLoginHistory
END
GO

CREATE Procedure spInsertUserLoginHistory
	@UserID			int,
	@LoginStatus	nchar(1),
	@Source         nvarchar(50)
AS
BEGIN
	INSERT INTO UserLoginHistory
	(
		UserID,
		LoginStatus,
		LoginDate,
		Source
	)
	VALUES
	(
		@UserID,
		@LoginStatus,
		getdate(),
		@Source
	)
END
GO

/*===============================================================
// Function: spSelectUsersWithLastName
// Description:
//   Selects the user list
//=============================================================*/
PRINT 'Creating spSelectUsersWithLastName...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectUsersWithLastName')
BEGIN
	DROP Procedure spSelectUsersWithLastName
END
GO

CREATE Procedure spSelectUsersWithLastName
	@LetterFilter	char(1)
AS
BEGIN
	SELECT UserID, EmailAddress, FirstName, LastName, Gender, CountryID, LanguageID,
		HomeTown, Birthday, ProfileText, TimezoneID, AvatarNumber,
		ProfilePicFilename, ProfilePicThumbnail, ProfilePicPreview, EnableSendEmails,
		LoginEnabled, UserPassword, FailedLoginCount, PasswordExpiryDate, LastLoginDate,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName, FacebookUserID
	FROM Users
	WHERE Deleted = 0
	AND LoginEnabled = 1
	AND SUBSTRING(LastName, 1, 1) = @LetterFilter
	ORDER BY LastName
END
GO

/*===============================================================
// Function: spSelectUserDetailsByFacebookID
// Description:
//   Selects the user details by facebook id
//=============================================================*/
PRINT 'Creating spSelectUserDetailsByFacebookID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectUserDetailsByFacebookID')
BEGIN
	DROP Procedure spSelectUserDetailsByFacebookID
END
GO

CREATE Procedure spSelectUserDetailsByFacebookID
	@FacebookUserID			bigint
AS
BEGIN
	SELECT UserID,GUID, EmailAddress, FirstName, LastName, Gender, Deleted, DeletedDate,
		HomeTown, Birthday, ProfilePicFilename, ProfilePicThumbnail, ProfilePicPreview,
		ProfileText, CountryID, LanguageID, TimezoneID, EnableSendEmails, AvatarNumber,
		LoginEnabled, UserPassword, FailedLoginCount, PasswordExpiryDate, LastLoginDate,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName, 
		FacebookUserID, FirstLogin
	FROM Users
	WHERE FacebookUserID = @FacebookUserID
END
GO


PRINT '== Finished createUsersStoredProcs.sql =='
GO
