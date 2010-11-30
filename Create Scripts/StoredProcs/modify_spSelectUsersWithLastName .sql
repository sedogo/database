USE [sedogo4]
GO
/****** Object:  StoredProcedure [dbo].[spSelectUsersWithLastName]    Script Date: 11/29/2010 21:04:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[spSelectUsersWithLastName]
	@LetterFilter	char(1)
AS
BEGIN
	SELECT UserID, EmailAddress, FirstName, LastName, Gender, CountryID, LanguageID,
		HomeTown, Birthday, ProfileText, TimezoneID, AvatarNumber,
		ProfilePicFilename, ProfilePicThumbnail, ProfilePicPreview, EnableSendEmails,
		LoginEnabled, UserPassword, FailedLoginCount, PasswordExpiryDate, LastLoginDate,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName, FacebookUserID, GUID
	FROM Users
	WHERE Deleted = 0
	AND LoginEnabled = 1
	AND SUBSTRING(LastName, 1, 1) = @LetterFilter
	ORDER BY LastName
END
