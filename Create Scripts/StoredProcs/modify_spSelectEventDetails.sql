/****** Object:  StoredProcedure [dbo].[spSelectEventDetails]    Script Date: 11/29/2010 20:11:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER Procedure [dbo].[spSelectEventDetails]
	@EventID			int
AS
BEGIN
	SELECT UserID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate, Deleted, 
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo, ShowOnDefaultPage,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName, EventGUID
	FROM Events
	WHERE EventID = @EventID
END
