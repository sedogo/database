USE [sedogo4]
GO
/****** Object:  StoredProcedure [dbo].[spSelectTrackingUsersByEventID]    Script Date: 11/29/2010 21:16:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER Procedure [dbo].[spSelectTrackingUsersByEventID]
	@EventID		int
AS
BEGIN
	SELECT T.TrackedEventID, T.EventID, T.UserID, T.ShowOnTimeline, 
		T.JoinPending, T.CreatedDate, T.LastUpdatedDate,
		U.EmailAddress, U.FirstName, U.LastName, U.Gender, U.HomeTown, U.Birthday,
		U.ProfilePicFilename, U.ProfilePicThumbnail, U.ProfilePicPreview, U.AvatarNumber, U.Gender, U.GUID
	FROM TrackedEvents T
	JOIN Users U
	ON T.UserID = U.UserID
	WHERE T.EventID = @EventID
	AND U.Deleted = 0
	ORDER BY U.LastName DESC
	
END
