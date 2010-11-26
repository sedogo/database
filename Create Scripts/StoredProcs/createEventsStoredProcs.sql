/*===============================================================
// Filename: createEventsStoredProcs.sql
// Date: 17/08/09
// --------------------------------------------------------------
// Description:
//   This file creates the Events stored procedures
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 17/08/09
// Revision history:
//=============================================================*/

PRINT '== Starting createEventsStoredProcs.sql =='
GO

/*===============================================================
// Function: spAddEvent
// Description:
//   Add an event to the database
//=============================================================*/
PRINT 'Creating spAddEvent...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddEvent')
	BEGIN
		DROP Procedure spAddEvent
	END
GO

CREATE Procedure spAddEvent
	@UserID						int,
	@EventName					nvarchar(200),
	@DateType					nchar(1),
	@StartDate					datetime,
	@RangeStartDate				datetime,
	@RangeEndDate				datetime,
	@BeforeBirthday				int,
	@CategoryID					int,
	@TimezoneID					int,
	@PrivateEvent				bit,
	@CreatedFromEventID			int,
	@EventDescription			nvarchar(max),
	@EventVenue					nvarchar(max),
	@MustDo						bit,
	@CreatedDate				datetime,
	@CreatedByFullName			nvarchar(200),
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200),
	@EventID					int OUTPUT
AS
BEGIN
	INSERT INTO Events
	(
		UserID,
		EventName,
		DateType,
		StartDate,
		RangeStartDate,
		RangeEndDate,
		BeforeBirthday,
		CategoryID,
		TimezoneID,
		PrivateEvent,
		CreatedFromEventID,
		EventDescription,
		EventVenue,
		MustDo,
		EventAchieved,
		Deleted,
		ShowOnDefaultPage,
		CreatedDate,
		CreatedByFullName,
		LastUpdatedDate,
		LastUpdatedByFullName
	)
	VALUES
	(
		@UserID,
		@EventName,
		@DateType,
		@StartDate,
		@RangeStartDate,
		@RangeEndDate,
		@BeforeBirthday,
		@CategoryID,
		@TimezoneID,
		@PrivateEvent,
		@CreatedFromEventID,
		@EventDescription,
		@EventVenue,
		@MustDo,
		0,		-- EventAchieved
		0,		-- Deleted
		0,		-- ShowOnDefaultPage
		@CreatedDate,
		@CreatedByFullName,
		@LastUpdatedDate,
		@LastUpdatedByFullName
	)
	
	SET @EventID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectEventDetails
// Description:
//   Gets event details
// --------------------------------------------------------------
// Parameters
//	 @EventID			int
//=============================================================*/
PRINT 'Creating spSelectEventDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventDetails')
BEGIN
	DROP Procedure spSelectEventDetails
END
GO

CREATE Procedure spSelectEventDetails
	@EventID			int
AS
BEGIN
	SELECT UserID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate, Deleted, 
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo, ShowOnDefaultPage,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Events
	WHERE EventID = @EventID
END
GO

/*===============================================================
// Function: spSelectFullEventList
// Description:
//   Selects the users event list
//=============================================================*/
PRINT 'Creating spSelectFullEventList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectFullEventList')
BEGIN
	DROP Procedure spSelectFullEventList
END
GO

CREATE Procedure spSelectFullEventList
	@UserID			int
AS
BEGIN
	SELECT EventID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Events
	WHERE Deleted = 0
	AND EventAchieved = 0
	AND UserID = @UserID
	ORDER BY StartDate
END
GO

/*===============================================================
// Function: spSelectAdministratorsEventList
// Description:
//   Selects the event list
//=============================================================*/
PRINT 'Creating spSelectAdministratorsEventList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectAdministratorsEventList')
BEGIN
	DROP Procedure spSelectAdministratorsEventList
END
GO

CREATE Procedure spSelectAdministratorsEventList
AS
BEGIN
	SELECT E.EventID, E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate,
		E.BeforeBirthday, E.CategoryID, E.TimezoneID, E.EventAchieved, E.EventAchievedDate, 
		E.PrivateEvent, E.CreatedFromEventID,
		E.EventDescription, E.EventVenue, E.MustDo, E.UserID, E.ShowOnDefaultPage,
		E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		E.CreatedDate, E.CreatedByFullName, E.LastUpdatedDate, E.LastUpdatedByFullName,
		U.FirstName, U.LastName, U.EmailAddress
	FROM Events E
	JOIN Users U
	ON E.UserID = U.UserID
	WHERE E.Deleted = 0
	AND U.Deleted = 0
	ORDER BY E.EventID DESC
END
GO

/*===============================================================
// Function: spSelectAdministratorsEventCount
// Description:
//   Selects the event count
//=============================================================*/
PRINT 'Creating spSelectAdministratorsEventCount...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectAdministratorsEventCount')
BEGIN
	DROP Procedure spSelectAdministratorsEventCount
END
GO

CREATE Procedure spSelectAdministratorsEventCount
AS
BEGIN
	SELECT COUNT(*)
	FROM Events E
	JOIN Users U
	ON E.UserID = U.UserID
	WHERE E.Deleted = 0
	AND U.Deleted = 0
END
GO

/*===============================================================
// Function: spSelectFullEventListByCategory
// Description:
//   Selects the users event list
//=============================================================*/
PRINT 'Creating spSelectFullEventListByCategory...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectFullEventListByCategory')
BEGIN
	DROP Procedure spSelectFullEventListByCategory
END
GO

CREATE Procedure spSelectFullEventListByCategory
	@UserID			int,
	@ShowPrivate	bit
AS
BEGIN
	SELECT EventID, UserID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Events
	WHERE Deleted = 0
	AND ( (@ShowPrivate = 1) OR (@ShowPrivate = 0 AND PrivateEvent = 0) )
	AND EventAchieved = 0
	AND UserID = @UserID
	
	UNION 
	
	SELECT E.EventID, E.UserID, E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate,
		E.BeforeBirthday, E.CategoryID, E.TimezoneID, E.EventAchieved, E.EventAchievedDate,
		E.PrivateEvent, E.CreatedFromEventID,
		E.EventDescription, E.EventVenue, E.MustDo,
		E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		E.CreatedDate, E.CreatedByFullName, E.LastUpdatedDate, E.LastUpdatedByFullName
	FROM Events E
	JOIN TrackedEvents T
	ON E.EventID = T.EventID
	WHERE E.Deleted = 0
	AND ( (@ShowPrivate = 1) OR (@ShowPrivate = 0 AND E.PrivateEvent = 0) )
	AND E.EventAchieved = 0
	AND T.UserID = @UserID
	AND T.ShowOnTimeline = 1
	AND T.JoinPending = 0 
	
	ORDER BY CategoryID
END
GO

/*===============================================================
// Function: spSelectEventList
// Description:
//   Selects the users event list
//=============================================================*/
PRINT 'Creating spSelectEventList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventList')
BEGIN
	DROP Procedure spSelectEventList
END
GO

CREATE Procedure spSelectEventList
	@UserID			int,
	@StartDate		datetime,
	@EndDate		datetime
AS
BEGIN
	SELECT EventID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Events
	WHERE Deleted = 0
	AND EventAchieved = 0
	AND StartDate >= @StartDate
	AND StartDate <= @EndDate
	AND UserID = @UserID
	ORDER BY StartDate
END
GO

/*===============================================================
// Function: spSelectFullEventListIncludingAchieved
// Description:
//   Selects the users event list
//=============================================================*/
PRINT 'Creating spSelectFullEventListIncludingAchieved...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectFullEventListIncludingAchieved')
BEGIN
	DROP Procedure spSelectFullEventListIncludingAchieved
END
GO

CREATE Procedure spSelectFullEventListIncludingAchieved
	@UserID			int
AS
BEGIN
	SELECT EventID, UserID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Events
	WHERE Deleted = 0
	AND UserID = @UserID
	ORDER BY StartDate
END
GO

/*===============================================================
// Function: spSelectAchievedEventList
// Description:
//   Selects the achieved event list
//=============================================================*/
PRINT 'Creating spSelectAchievedEventList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectAchievedEventList')
BEGIN
	DROP Procedure spSelectAchievedEventList
END
GO

CREATE Procedure spSelectAchievedEventList
	@UserID			int
AS
BEGIN
	SELECT EventID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Events
	WHERE Deleted = 0
	AND EventAchieved = 1
	AND UserID = @UserID
	ORDER BY EventAchievedDate DESC
END
GO

/*===============================================================
// Function: spSelectNotAchievedEventList
// Description:
//   Selects the achieved event list
//=============================================================*/
PRINT 'Creating spSelectNotAchievedEventList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectNotAchievedEventList')
BEGIN
	DROP Procedure spSelectNotAchievedEventList
END
GO

-- =============================================
-- Author:		Nikita Knyazev
-- Create date: 21.07.2010
-- Description:	get a list of events not yet achieved by a user
-- =============================================
CREATE Procedure [dbo].[spSelectNotAchievedEventList]
	@UserID			int
AS
BEGIN
	SELECT EventID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Events
	WHERE Deleted = 0
	AND EventAchieved = 0
	AND UserID = @UserID
	ORDER BY StartDate DESC
END

GO

/*===============================================================
// Function: spSelectFullEventListIncludingAchievedByCategory
// Description:
//   Selects the users event list
//=============================================================*/
PRINT 'Creating spSelectFullEventListIncludingAchievedByCategory...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectFullEventListIncludingAchievedByCategory')
BEGIN
	DROP Procedure spSelectFullEventListIncludingAchievedByCategory
END
GO

CREATE Procedure spSelectFullEventListIncludingAchievedByCategory
	@UserID			int,
	@ShowPrivate	bit
AS
BEGIN
	SELECT EventID, UserID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Events
	WHERE Deleted = 0
	AND ( (@ShowPrivate = 1) OR (@ShowPrivate = 0 AND PrivateEvent = 0) )
	AND UserID = @UserID
	
	UNION 
	
	SELECT E.EventID, E.UserID, E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate,
		E.BeforeBirthday, E.CategoryID, E.TimezoneID, E.EventAchieved, E.EventAchievedDate,
		E.PrivateEvent, E.CreatedFromEventID,
		E.EventDescription, E.EventVenue, E.MustDo,
		E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		E.CreatedDate, E.CreatedByFullName, E.LastUpdatedDate, E.LastUpdatedByFullName
	FROM Events E
	JOIN TrackedEvents T
	ON E.EventID = T.EventID
	WHERE E.Deleted = 0
	AND ( (@ShowPrivate = 1) OR (@ShowPrivate = 0 AND E.PrivateEvent = 0) )
	AND E.EventAchieved = 0
	AND T.UserID = @UserID
	AND T.ShowOnTimeline = 1
	AND T.JoinPending = 0
	
	ORDER BY CategoryID

END
GO

/*===============================================================
// Function: spSelectEventListIncludingAchieved
// Description:
//   Selects the users event list
//=============================================================*/
PRINT 'Creating spSelectEventListIncludingAchieved...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventListIncludingAchieved')
BEGIN
	DROP Procedure spSelectEventListIncludingAchieved
END
GO

CREATE Procedure spSelectEventListIncludingAchieved
	@UserID			int,
	@StartDate		datetime,
	@EndDate		datetime
AS
BEGIN
	SELECT EventID, UserID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Events
	WHERE Deleted = 0
	AND StartDate >= @StartDate
	AND StartDate <= @EndDate
	AND UserID = @UserID
	ORDER BY StartDate
END
GO

/*===============================================================
// Function: spUpdateEvent
// Description:
//   Update event details
//=============================================================*/
PRINT 'Creating spUpdateEvent...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateEvent')
BEGIN
	DROP Procedure spUpdateEvent
END
GO

CREATE Procedure spUpdateEvent
	@EventID						int,
	@EventName						nvarchar(200),
	@DateType						nchar(1),
	@StartDate						datetime,
	@RangeStartDate					datetime,
	@RangeEndDate					datetime,
	@BeforeBirthday					int,
	@CategoryID						int,
	@TimezoneID						int,
	@PrivateEvent					bit,
	@CreatedFromEventID				int,
	@EventAchieved					bit,
	@EventAchievedDate				datetime,
	@EventDescription				nvarchar(max),
	@EventVenue						nvarchar(max),
	@MustDo							bit,
	@ShowOnDefaultPage				bit,
	@LastUpdatedDate				datetime,
	@LastUpdatedByFullName			nvarchar(200)
AS
BEGIN
	UPDATE Events
	SET EventName				= @EventName,
		DateType				= @DateType,
		StartDate				= @StartDate,
		RangeStartDate			= @RangeStartDate,
		RangeEndDate			= @RangeEndDate,
		BeforeBirthday			= @BeforeBirthday,
		CategoryID				= @CategoryID,
		TimezoneID				= @TimezoneID,
		PrivateEvent			= @PrivateEvent,
		CreatedFromEventID		= @CreatedFromEventID,
		EventAchieved			= @EventAchieved,
		EventAchievedDate		= @EventAchievedDate,
		EventDescription		= @EventDescription,
		EventVenue				= @EventVenue,
		MustDo					= @MustDo,
		ShowOnDefaultPage		= @ShowOnDefaultPage,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE EventID = @EventID
END
GO

/*===============================================================
// Function: spUpdateEventPics
// Description:
//   Update event details
//=============================================================*/
PRINT 'Creating spUpdateEventPics...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateEventPics')
BEGIN
	DROP Procedure spUpdateEventPics
END
GO

CREATE Procedure spUpdateEventPics
	@EventID						int,
	@EventPicFilename				nvarchar(200),
	@EventPicThumbnail				nvarchar(200),
	@EventPicPreview				nvarchar(200),
	@LastUpdatedDate				datetime,
	@LastUpdatedByFullName			nvarchar(200)
AS
BEGIN
	UPDATE Events
	SET EventPicFilename		= @EventPicFilename,
		EventPicThumbnail		= @EventPicThumbnail,
		EventPicPreview			= @EventPicPreview,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE EventID = @EventID
END
GO

/*===============================================================
// Function: spDeleteEvent
// Description:
//   Delete event
//=============================================================*/
PRINT 'Creating spDeleteEvent...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteEvent')
BEGIN
	DROP Procedure spDeleteEvent
END
GO

CREATE Procedure spDeleteEvent
	@EventID			int
AS
BEGIN
	UPDATE Events
	SET Deleted = 1
	WHERE EventID = @EventID
END
GO

/*===============================================================
// Function: spSelectEventCountNotAchievedByUserID
// Description:
//   Selects the event count
//=============================================================*/
PRINT 'Creating spSelectEventCountNotAchievedByUserID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventCountNotAchievedByUserID')
BEGIN
	DROP Procedure spSelectEventCountNotAchievedByUserID
END
GO

CREATE Procedure spSelectEventCountNotAchievedByUserID
	@UserID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM Events
	WHERE Deleted = 0
	AND EventAchieved = 0
	AND UserID = @UserID
END
GO

/*===============================================================
// Function: spSelectEventCountAchievedByUserID
// Description:
//   Selects the event count
//=============================================================*/
PRINT 'Creating spSelectEventCountAchievedByUserID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventCountAchievedByUserID')
BEGIN
	DROP Procedure spSelectEventCountAchievedByUserID
END
GO

CREATE Procedure spSelectEventCountAchievedByUserID
	@UserID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM Events
	WHERE Deleted = 0
	AND EventAchieved = 1
	AND UserID = @UserID
END
GO

/*===============================================================
// Function: spAddEventComment
// Description:
//   Add an event comment to the database
//=============================================================*/
PRINT 'Creating spAddEventComment...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddEventComment')
	BEGIN
		DROP Procedure spAddEventComment
	END
GO

CREATE Procedure spAddEventComment
	@EventID				int,
	@PostedByUserID			int,
	@EventImageFilename		nvarchar(200),
	@EventImagePreview		nvarchar(200),
	@EventVideoLink			nvarchar(1000),
	@EventLink				nvarchar(200),
	@CommentText			nvarchar(max),
	@CreatedDate			datetime,
	@CreatedByFullName		nvarchar(200),
	@LastUpdatedDate		datetime,
	@LastUpdatedByFullName	nvarchar(200),
	@EventCommentID			int OUTPUT
AS
BEGIN
	INSERT INTO EventComments
	(
		EventID,
		PostedByUserID,
		EventImageFilename,
		EventImagePreview,
		EventVideoLink,
		EventLink,
		CommentText,
		Deleted,
		CreatedDate,
		CreatedByFullName,
		LastUpdatedDate,
		LastUpdatedByFullName
	)
	VALUES
	(
		@EventID,
		@PostedByUserID,
		@EventImageFilename,
		@EventImagePreview,
		@EventVideoLink,
		@EventLink,
		@CommentText,
		0,		-- Deleted
		@CreatedDate,
		@CreatedByFullName,
		@LastUpdatedDate,
		@LastUpdatedByFullName
	)
	
	SET @EventCommentID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectEventCommentDetails
// Description:
//   Gets event comment details
// --------------------------------------------------------------
// Parameters
//	 @EventCommentID			int
//=============================================================*/
PRINT 'Creating spSelectEventCommentDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventCommentDetails')
BEGIN
	DROP Procedure spSelectEventCommentDetails
END
GO

CREATE Procedure spSelectEventCommentDetails
	@EventCommentID			int
AS
BEGIN
	SELECT EventID, PostedByUserID, CommentText, Deleted,
		EventImageFilename, EventImagePreview, EventVideoFilename, EventVideoLink, EventLink,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM EventComments
	WHERE EventCommentID = @EventCommentID
END
GO

/*===============================================================
// Function: spSelectEventCommentsList
// Description:
//   Selects the events comments
//=============================================================*/
PRINT 'Creating spSelectEventCommentsList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventCommentsList')
BEGIN
	DROP Procedure spSelectEventCommentsList
END
GO

CREATE Procedure spSelectEventCommentsList
	@EventID		int
AS
BEGIN
	SELECT C.EventCommentID, C.PostedByUserID, C.CommentText, 
		C.EventImageFilename, C.EventImagePreview, C.EventVideoFilename, C.EventVideoLink, C.EventLink,
		C.CreatedDate, C.CreatedByFullName, C.LastUpdatedDate, C.LastUpdatedByFullName,
		U.FirstName, U.LastName, U.EmailAddress, U.ProfilePicThumbnail, U.ProfilePicPreview, U.AvatarNumber,
		U.Gender
	FROM EventComments C
	JOIN Users U
	ON C.PostedByUserID = U.UserID
	WHERE C.Deleted = 0
	AND C.EventID = @EventID
	ORDER BY C.CreatedDate DESC
END
GO

/*===============================================================
// Function: spSelectEventCommentCountForEvent
// Description:
//   Selects the events comment count
//=============================================================*/
PRINT 'Creating spSelectEventCommentCountForEvent...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventCommentCountForEvent')
BEGIN
	DROP Procedure spSelectEventCommentCountForEvent
END
GO

CREATE Procedure spSelectEventCommentCountForEvent
	@EventID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM EventComments
	WHERE Deleted = 0
	AND EventID = @EventID
END
GO

/*===============================================================
// Function: spUpdateEventComment
// Description:
//   Update event comment
//=============================================================*/
PRINT 'Creating spUpdateEventComment...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateEventComment')
BEGIN
	DROP Procedure spUpdateEventComment
END
GO

CREATE Procedure spUpdateEventComment
	@EventCommentID				int,
	@CommentText				nvarchar(max),
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200)
AS
BEGIN
	UPDATE EventComments
	SET CommentText				= @CommentText,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE EventCommentID = @EventCommentID
END
GO

/*===============================================================
// Function: spDeleteEventComment
// Description:
//   Delete event comment
//=============================================================*/
PRINT 'Creating spDeleteEventComment...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteEventComment')
BEGIN
	DROP Procedure spDeleteEventComment
END
GO

CREATE Procedure spDeleteEventComment
	@EventCommentID				int,
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200)
AS
BEGIN
	UPDATE EventComments
	SET Deleted					= 1,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE EventCommentID = @EventCommentID
END
GO

/*===============================================================
// Function: spSearchEvents
// Description:
//   Search events
//=============================================================*/
PRINT 'Creating spSearchEvents...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSearchEvents')
BEGIN
	DROP Procedure spSearchEvents
END
GO

CREATE Procedure spSearchEvents
	@UserID			int,
	@SearchText		nvarchar(1000)
AS
BEGIN
	SELECT E.EventID, E.UserID, E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate,
		E.BeforeBirthday, E.CategoryID, E.TimezoneID, E.EventAchieved, E.EventAchievedDate,
		E.PrivateEvent, E.CreatedFromEventID,
		E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		E.CreatedDate, E.CreatedByFullName, E.LastUpdatedDate, E.LastUpdatedByFullName,
		U.EmailAddress, U.FirstName, U.LastName, U.Gender, U.HomeTown, U.ProfilePicThumbnail
	FROM Events E
	JOIN Users U
	ON E.UserID = U.UserID
	WHERE E.Deleted = 0
	--AND E.EventAchieved = 0
	AND E.PrivateEvent = 0
	AND E.UserID <> @UserID			-- Do not return events belonging to the searching user
	AND ( (@SearchText = '') 
	 OR (UPPER(E.EventName) LIKE '%'+UPPER(@SearchText)+'%')
	 OR (UPPER(CONVERT(nvarchar(1000),E.EventVenue)) LIKE '%'+UPPER(@SearchText)+'%')
	 OR (UPPER(CONVERT(nvarchar(1000),E.EventDescription)) LIKE '%'+UPPER(@SearchText)+'%')
	 OR (UPPER(U.FirstName) + ' ' + UPPER(U.LastName) LIKE '%'+UPPER(@SearchText)+'%') 
	) 
	ORDER BY E.StartDate
END
GO

/*===============================================================
// Function: spSearchEventsAdvanced
// Description:
//   Search events
//=============================================================*/
PRINT 'Creating spSearchEventsAdvanced...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSearchEventsAdvanced')
BEGIN
	DROP Procedure spSearchEventsAdvanced
END
GO

CREATE Procedure spSearchEventsAdvanced
	@UserID				int,
	@EventName			nvarchar(1000),
	@EventVenue			nvarchar(1000),
	@OwnerName			nvarchar(1000),
	@CategoryID			int,
	@StartDate			datetime,
	@EndDate			datetime,
	@RecentlyAdded		int,
	@RecentlyUpdated	int,
	@DefinitlyDo		nchar(1)
AS
BEGIN
	DECLARE @TempSearchList TABLE
	(
		EventID							int,
		UserID							int,
		EventName						nvarchar(200),
		DateType						nchar(1),
		StartDate						datetime,
		RangeStartDate					datetime,
		RangeEndDate					datetime,
		BeforeBirthday					int,
		CategoryID						int,
		TimezoneID						int,
		EventAchieved					bit,
		PrivateEvent					bit,
		CreatedFromEventID				int,
		EventVenue						nvarchar(max),
		MustDo							bit,
		EventPicFilename				nvarchar(200),
		EventPicThumbnail				nvarchar(200),
		EventPicPreview					nvarchar(200),
		CreatedDate						datetime,
		CreatedByFullName				nvarchar(200),
		LastUpdatedDate					datetime,
		LastUpdatedByFullName			nvarchar(200),
		EmailAddress					nvarchar(200),
		FirstName						nvarchar(200),
		LastName						nvarchar(200),
		Gender							nchar(1),
		HomeTown						nvarchar(200),
		ProfilePicThumbnail				nvarchar(200),
		Birthday						datetime,
		BeforeBirthdayDate				datetime,
		DaysFromCreatedDate				int,
		DaysFromLastUpdatedDate			int
	)

	INSERT INTO @TempSearchList
	(
		EventID, UserID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, PrivateEvent,
		CreatedFromEventID, EventVenue, MustDo, EventPicFilename, EventPicThumbnail,
		EventPicPreview, CreatedDate, CreatedByFullName, LastUpdatedDate,
		LastUpdatedByFullName, EmailAddress, FirstName, LastName, Gender,
		HomeTown, ProfilePicThumbnail, Birthday, BeforeBirthdayDate,
		DaysFromCreatedDate, DaysFromLastUpdatedDate
	)
	SELECT E.EventID, E.UserID, E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate,
		E.BeforeBirthday, E.CategoryID, E.TimezoneID, E.EventAchieved, E.PrivateEvent, E.CreatedFromEventID,
		E.EventVenue, E.MustDo,
		E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		E.CreatedDate, E.CreatedByFullName, E.LastUpdatedDate, E.LastUpdatedByFullName,
		U.EmailAddress, U.FirstName, U.LastName, U.Gender, U.HomeTown, U.ProfilePicThumbnail,
		U.Birthday, DATEADD(yy, E.BeforeBirthday, U.Birthday) AS BeforeBirthdayDate,
		DATEDIFF(d,E.CreatedDate,getdate()) AS DaysFromCreatedDate,
		DATEDIFF(d,E.LastUpdatedDate,getdate()) AS DaysFromLastUpdatedDate
	FROM Events E
	JOIN Users U
	ON E.UserID = U.UserID
	WHERE E.Deleted = 0
	--AND E.EventAchieved = 0
	AND E.PrivateEvent = 0
	AND E.UserID <> @UserID			-- Do not return events belonging to the searching user
	AND ( (UPPER(E.EventName) LIKE '%'+UPPER(@EventName)+'%')
	 AND (UPPER(ISNULL(E.EventVenue,'')) LIKE '%'+UPPER(@EventVenue)+'%')
	 AND ((@CategoryID = -1) OR (E.CategoryID = @CategoryID))
	 AND (UPPER(U.FirstName) + ' ' + UPPER(U.LastName) LIKE '%'+UPPER(@OwnerName)+'%') 
	 ) 
	 
	 IF @RecentlyAdded > 0
	 BEGIN
		 DELETE @TempSearchList
		 WHERE DaysFromCreatedDate > @RecentlyAdded
	 END
	 IF @RecentlyUpdated > 0
	 BEGIN
		 DELETE @TempSearchList
		 WHERE DaysFromLastUpdatedDate > @RecentlyAdded
	 END
	 IF @DefinitlyDo = 'D'
	 BEGIN
		 DELETE @TempSearchList
		 WHERE MustDo = 0
	 END
	 
	-- Now filter out based on dates
	--DELETE @TempSearchList
	--WHERE BeforeBirthday > 0
	--AND ( BeforeBirthdayDate > @EndDate )
	--AND ( BeforeBirthdayDate < @StartDate OR BeforeBirthdayDate > @EndDate )

	DELETE @TempSearchList
	WHERE StartDate IS NOT NULL
	AND ( StartDate < @StartDate OR StartDate > @EndDate )

	DELETE @TempSearchList
	WHERE RangeStartDate IS NOT NULL
	AND ( RangeStartDate < @StartDate OR RangeEndDate > @EndDate )
	
	SELECT *
	FROM @TempSearchList
	ORDER BY StartDate
END
GO

/*===============================================================
// Function: spSelectHomePageEvents
// Description:
//   Search events
//=============================================================*/
PRINT 'Creating spSelectHomePageEvents...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectHomePageEvents')
BEGIN
	DROP Procedure spSelectHomePageEvents
END
GO

CREATE Procedure spSelectHomePageEvents
AS
BEGIN
	SELECT TOP 50 E.EventID, E.UserID, E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate,
		E.BeforeBirthday, E.CategoryID, E.TimezoneID, E.EventAchieved, E.PrivateEvent, E.CreatedFromEventID,
		E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		E.CreatedDate, E.CreatedByFullName, E.LastUpdatedDate, E.LastUpdatedByFullName,
		U.EmailAddress, U.FirstName, U.LastName, U.Gender, U.HomeTown, U.ProfilePicThumbnail
	FROM Events E
	JOIN Users U
	ON E.UserID = U.UserID
	WHERE E.Deleted = 0
	AND E.ShowOnDefaultPage = 1
	--AND E.EventAchieved = 0
	AND E.PrivateEvent = 0
	--AND E.CategoryID = 1
	--ORDER BY NEWID()
	ORDER BY CreatedDate DESC
	
END
GO

/*===============================================================
// Function: spAddTrackedEvent
// Description:
//   Add a tracked event 
//=============================================================*/
PRINT 'Creating spAddTrackedEvent...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddTrackedEvent')
	BEGIN
		DROP Procedure spAddTrackedEvent
	END
GO

CREATE Procedure spAddTrackedEvent
	@EventID				int,
	@UserID					int,
	@ShowOnTimeline			bit,
	@JoinPending			bit,
	@CreatedDate			datetime,
	@LastUpdatedDate		datetime,
	@TrackedEventID			int OUTPUT
AS
BEGIN
	INSERT INTO TrackedEvents
	(
		EventID,
		UserID,
		ShowOnTimeline,
		JoinPending,
		CreatedDate,
		LastUpdatedDate
	)
	VALUES
	(
		@EventID,
		@UserID,
		@ShowOnTimeline,
		@JoinPending,
		@CreatedDate,
		@LastUpdatedDate
	)
	
	SET @TrackedEventID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectTrackedEventDetails
// Description:
//   Gets tracked event details
// --------------------------------------------------------------
// Parameters
//	 @TrackedEventID			int
//=============================================================*/
PRINT 'Creating spSelectTrackedEventDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectTrackedEventDetails')
BEGIN
	DROP Procedure spSelectTrackedEventDetails
END
GO

CREATE Procedure spSelectTrackedEventDetails
	@TrackedEventID			int
AS
BEGIN
	SELECT EventID, UserID, ShowOnTimeline, JoinPending,
		CreatedDate, LastUpdatedDate
	FROM TrackedEvents
	WHERE TrackedEventID = @TrackedEventID
END
GO

/*===============================================================
// Function: spSelectTrackedEventListByUserID
// Description:
//   Selects the tracked events list
//=============================================================*/
PRINT 'Creating spSelectTrackedEventListByUserID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectTrackedEventListByUserID')
BEGIN
	DROP Procedure spSelectTrackedEventListByUserID
END
GO

CREATE Procedure spSelectTrackedEventListByUserID
	@UserID		int
AS
BEGIN
	SELECT T.TrackedEventID, T.EventID, T.UserID, T.ShowOnTimeline, 
		T.JoinPending, T.CreatedDate, T.LastUpdatedDate,
		E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate, E.BeforeBirthday,
		E.EventAchieved, E.EventAchievedDate,E.MustDo, E.PrivateEvent,
		E.CategoryID, E.TimezoneID, E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		U.FirstName, U.LastName, U.EmailAddress
	FROM TrackedEvents T
	JOIN Events E
	ON T.EventID = E.EventID
	JOIN Users U
	ON U.UserID = E.UserID
	WHERE T.UserID = @UserID
	AND E.Deleted = 0
	AND T.ShowOnTimeline = 0
	ORDER BY E.EventName DESC
	
END
GO

/*===============================================================
// Function: spSelectJoinedEventListByUserID
// Description:
//   Selects the tracked events list
//=============================================================*/
PRINT 'Creating spSelectJoinedEventListByUserID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectJoinedEventListByUserID')
BEGIN
	DROP Procedure spSelectJoinedEventListByUserID
END
GO

CREATE Procedure spSelectJoinedEventListByUserID
	@UserID		int
AS
BEGIN
	SELECT T.TrackedEventID, T.EventID, T.UserID, T.ShowOnTimeline, 
		T.JoinPending, T.CreatedDate, T.LastUpdatedDate,
		E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate, E.BeforeBirthday,
		E.EventAchieved, E.EventAchievedDate,
		E.CategoryID, E.TimezoneID, E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		U.FirstName, U.LastName, U.EmailAddress
	FROM TrackedEvents T
	JOIN Events E
	ON T.EventID = E.EventID
	JOIN Users U
	ON U.UserID = E.UserID
	WHERE T.UserID = @UserID
	AND E.Deleted = 0
	AND T.ShowOnTimeline = 1
	ORDER BY E.EventName DESC
	
END
GO

/*===============================================================
// Function: spSelectTrackingUsersByEventID
// Description:
//   Selects the list of users tracking an event
//=============================================================*/
PRINT 'Creating spSelectTrackingUsersByEventID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectTrackingUsersByEventID')
BEGIN
	DROP Procedure spSelectTrackingUsersByEventID
END
GO

CREATE Procedure spSelectTrackingUsersByEventID
	@EventID		int
AS
BEGIN
	SELECT T.TrackedEventID, T.EventID, T.UserID, T.ShowOnTimeline, 
		T.JoinPending, T.CreatedDate, T.LastUpdatedDate,
		U.EmailAddress, U.FirstName, U.LastName, U.Gender, U.HomeTown, U.Birthday,
		U.ProfilePicFilename, U.ProfilePicThumbnail, U.ProfilePicPreview, U.AvatarNumber, U.Gender
	FROM TrackedEvents T
	JOIN Users U
	ON T.UserID = U.UserID
	WHERE T.EventID = @EventID
	AND U.Deleted = 0
	ORDER BY U.LastName DESC
	
END
GO

/*===============================================================
// Function: spSelectTrackingUserCountByEventID
// Description:
//   Selects the count of users tracking an event
//=============================================================*/
PRINT 'Creating spSelectTrackingUserCountByEventID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectTrackingUserCountByEventID')
BEGIN
	DROP Procedure spSelectTrackingUserCountByEventID
END
GO

CREATE Procedure spSelectTrackingUserCountByEventID
	@EventID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM TrackedEvents T
	JOIN Users U
	ON T.UserID = U.UserID
	WHERE T.EventID = @EventID
	AND U.Deleted = 0
	AND T.ShowOnTimeline = 0
	
END
GO

/*===============================================================
// Function: spSelectTrackedEventIDFromEventIDUserID
// Description:
//   Selects the count of users tracking an event
//=============================================================*/
PRINT 'Creating spSelectTrackedEventIDFromEventIDUserID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectTrackedEventIDFromEventIDUserID')
BEGIN
	DROP Procedure spSelectTrackedEventIDFromEventIDUserID
END
GO

CREATE Procedure spSelectTrackedEventIDFromEventIDUserID
	@EventID		int,
	@UserID			int
AS
BEGIN
	SELECT TrackedEventID
	FROM TrackedEvents
	WHERE EventID = @EventID
	AND UserID = @UserID
	
END
GO

/*===============================================================
// Function: spSelectMemberUserCountByEventID
// Description:
//   Selects the count of users tracking an event
//=============================================================*/
PRINT 'Creating spSelectMemberUserCountByEventID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectMemberUserCountByEventID')
BEGIN
	DROP Procedure spSelectMemberUserCountByEventID
END
GO

CREATE Procedure spSelectMemberUserCountByEventID
	@EventID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM TrackedEvents T
	JOIN Users U
	ON T.UserID = U.UserID
	WHERE T.EventID = @EventID
	AND U.Deleted = 0
	AND T.ShowOnTimeline = 1
	
END
GO

/*===============================================================
// Function: spSelectPendingMemberUserCountByEventID
// Description:
//   Selects the count of users tracking an event
//=============================================================*/
PRINT 'Creating spSelectPendingMemberUserCountByEventID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectPendingMemberUserCountByEventID')
BEGIN
	DROP Procedure spSelectPendingMemberUserCountByEventID
END
GO

CREATE Procedure spSelectPendingMemberUserCountByEventID
	@EventID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM TrackedEvents T
	JOIN Users U
	ON T.UserID = U.UserID
	WHERE T.EventID = @EventID
	AND U.Deleted = 0
	AND T.JoinPending = 1
	
END
GO

/*===============================================================
// Function: spSelectPendingMemberUserCountByUserID
// Description:
//   
//=============================================================*/
PRINT 'Creating spSelectPendingMemberUserCountByUserID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectPendingMemberUserCountByUserID')
BEGIN
	DROP Procedure spSelectPendingMemberUserCountByUserID
END
GO

CREATE Procedure spSelectPendingMemberUserCountByUserID
	@UserID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM TrackedEvents T
	JOIN Events E
	ON T.EventID = E.EventID
	WHERE E.UserID = @UserID
	AND E.Deleted = 0
	AND T.JoinPending = 1
	
END
GO

/*===============================================================
// Function: spSelectPendingMemberRequestsByUserID
// Description:
//   
//=============================================================*/
PRINT 'Creating spSelectPendingMemberRequestsByUserID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectPendingMemberRequestsByUserID')
BEGIN
	DROP Procedure spSelectPendingMemberRequestsByUserID
END
GO

CREATE Procedure spSelectPendingMemberRequestsByUserID
	@UserID		int
AS
BEGIN
	SELECT T.TrackedEventID, T.EventID, T.UserID, T.CreatedDate, 
		T.LastUpdatedDate, T.ShowOnTimeline, T.JoinPending,
		E.EventName, E.EventPicFilename, E.EventPicThumbnail,
		E.EventPicPreview, E.CategoryID, E.DateType, E.StartDate,
		E.RangeStartDate, E.RangeEndDate, E.BeforeBirthday, 
		E.EventDescription, E.MustDo, E.EventVenue,
		U.FirstName, U.LastName
	FROM TrackedEvents T
	JOIN Events E
	ON T.EventID = E.EventID
	JOIN Users U
	ON U.UserID = T.UserID
	WHERE E.UserID = @UserID
	AND E.Deleted = 0
	AND T.JoinPending = 1
	
END
GO

/*===============================================================
// Function: spSelectPendingMemberRequestsByEventID
// Description:
//   
//=============================================================*/
PRINT 'Creating spSelectPendingMemberRequestsByEventID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectPendingMemberRequestsByEventID')
BEGIN
	DROP Procedure spSelectPendingMemberRequestsByEventID
END
GO

CREATE Procedure spSelectPendingMemberRequestsByEventID
	@EventID		int
AS
BEGIN
	SELECT T.TrackedEventID, T.EventID, T.UserID, T.CreatedDate, 
		T.LastUpdatedDate, T.ShowOnTimeline, T.JoinPending,
		E.EventName, E.EventPicFilename, E.EventPicThumbnail,
		E.EventPicPreview, E.CategoryID, E.DateType, E.StartDate,
		E.RangeStartDate, E.RangeEndDate, E.BeforeBirthday, 
		E.EventDescription, E.MustDo, E.EventVenue,
		U.FirstName, U.LastName, U.ProfilePicThumbnail, U.AvatarNumber, U.Gender
	FROM TrackedEvents T
	JOIN Events E
	ON T.EventID = E.EventID
	JOIN Users U
	ON U.UserID = T.UserID
	WHERE E.EventID = @EventID
	AND E.Deleted = 0
	AND T.JoinPending = 1
	
END
GO

/*===============================================================
// Function: spUpdateTrackedEvent
// Description:
//   Delete tracked event
//=============================================================*/
PRINT 'Creating spUpdateTrackedEvent...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateTrackedEvent')
BEGIN
	DROP Procedure spUpdateTrackedEvent
END
GO

CREATE Procedure spUpdateTrackedEvent
	@TrackedEventID				int,
	@ShowOnTimeline				bit,
	@JoinPending				bit,
	@LastUpdatedDate			datetime
AS
BEGIN
	UPDATE TrackedEvents
	SET ShowOnTimeline		= @ShowOnTimeline,
		JoinPending			= @JoinPending,
		LastUpdatedDate		= @LastUpdatedDate
	WHERE TrackedEventID = @TrackedEventID

END
GO

/*===============================================================
// Function: spDeleteTrackedEvent
// Description:
//   Delete tracked event
//=============================================================*/
PRINT 'Creating spDeleteTrackedEvent...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteTrackedEvent')
BEGIN
	DROP Procedure spDeleteTrackedEvent
END
GO

CREATE Procedure spDeleteTrackedEvent
	@TrackedEventID				int
AS
BEGIN
	DELETE TrackedEvents
	WHERE TrackedEventID = @TrackedEventID

END
GO

/*===============================================================
// Function: spSelectTrackedEventID
// Description:
//   
// --------------------------------------------------------------
// Parameters
//	 @TrackedEventID			int
//=============================================================*/
PRINT 'Creating spSelectTrackedEventID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectTrackedEventID')
BEGIN
	DROP Procedure spSelectTrackedEventID
END
GO

CREATE Procedure spSelectTrackedEventID
	@EventID			int,
	@UserID				int
AS
BEGIN
	SELECT TrackedEventID
	FROM TrackedEvents
	WHERE EventID = @EventID
	AND UserID = @UserID
END
GO

/*===============================================================
// Function: spSelectTrackedEventCountByUserID
// Description:
//   Selects the tracked events for a user
//=============================================================*/
PRINT 'Creating spSelectTrackedEventCountByUserID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectTrackedEventCountByUserID')
BEGIN
	DROP Procedure spSelectTrackedEventCountByUserID
END
GO

CREATE Procedure spSelectTrackedEventCountByUserID
	@UserID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM TrackedEvents T
	JOIN Events E
	ON T.EventID = E.EventID
	WHERE T.UserID = @UserID
	AND E.Deleted = 0
	AND T.ShowOnTimeline = 0
	
END
GO

/*===============================================================
// Function: spSelectJoinedEventCountByUserID
// Description:
//   Selects the tracked events for a user
//=============================================================*/
PRINT 'Creating spSelectJoinedEventCountByUserID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectJoinedEventCountByUserID')
BEGIN
	DROP Procedure spSelectJoinedEventCountByUserID
END
GO

CREATE Procedure spSelectJoinedEventCountByUserID
	@UserID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM TrackedEvents T
	JOIN Events E
	ON T.EventID = E.EventID
	WHERE T.UserID = @UserID
	AND E.Deleted = 0
	AND T.ShowOnTimeline = 1
	
END
GO

/*===============================================================
// Function: spAddEventInvite
// Description:
//   Add an event invite to the database
//=============================================================*/
PRINT 'Creating spAddEventInvite...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddEventInvite')
	BEGIN
		DROP Procedure spAddEventInvite
	END
GO

CREATE Procedure spAddEventInvite
	@EventID						int,
	@GUID							nvarchar(50),
	@UserID							int,
	@EmailAddress					nvarchar(200),
	@InviteAdditionalText			nvarchar(max),
	@InviteEmailSent				bit,
	@InviteEmailSentEmailAddress	nvarchar(200),
	@InviteEmailSentDate			datetime,
	@CreatedDate					datetime,
	@CreatedByFullName				nvarchar(200),
	@LastUpdatedDate				datetime,
	@LastUpdatedByFullName			nvarchar(200),
	@EventInviteID					int OUTPUT
AS
BEGIN
	INSERT INTO EventInvites
	(
		EventID,
		GUID,
		UserID,
		EmailAddress,
		InviteAdditionalText,
		InviteEmailSent,
		InviteEmailSentEmailAddress,
		InviteEmailSentDate,
		Deleted,
		InviteAccepted,
		InviteDeclined,
		CreatedDate,
		CreatedByFullName,
		LastUpdatedDate,
		LastUpdatedByFullName
	)
	VALUES
	(
		@EventID,
		@GUID,
		@UserID,
		@EmailAddress,
		@InviteAdditionalText,
		@InviteEmailSent,
		@InviteEmailSentEmailAddress,
		@InviteEmailSentDate,
		0,		-- Deleted
		0,		-- InviteAccepted
		0,		-- InviteDeclined
		@CreatedDate,
		@CreatedByFullName,
		@LastUpdatedDate,
		@LastUpdatedByFullName
	)
	
	SET @EventInviteID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectEventInviteDetails
// Description:
//   Gets event invite details
// --------------------------------------------------------------
// Parameters
//	 @EventInviteID			int
//=============================================================*/
PRINT 'Creating spSelectEventInviteDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventInviteDetails')
BEGIN
	DROP Procedure spSelectEventInviteDetails
END
GO

CREATE Procedure spSelectEventInviteDetails
	@EventInviteID			int
AS
BEGIN
	SELECT EventID, GUID, UserID, EmailAddress, InviteAdditionalText, Deleted,
		InviteEmailSent, InviteEmailSentEmailAddress, InviteEmailSentDate,
		InviteAccepted, InviteAcceptedDate, InviteDeclined, InviteDeclinedDate,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM EventInvites
	WHERE EventInviteID = @EventInviteID
END
GO

/*===============================================================
// Function: spSelectEventInvitesList
// Description:
//   Selects the events invites
//=============================================================*/
PRINT 'Creating spSelectEventInvitesList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventInvitesList')
BEGIN
	DROP Procedure spSelectEventInvitesList
END
GO

CREATE Procedure spSelectEventInvitesList
	@EventID		int
AS
BEGIN
	SELECT EventInviteID, GUID, UserID, EmailAddress, InviteAdditionalText, 
		InviteEmailSent, InviteEmailSentEmailAddress, InviteEmailSentDate,
		InviteAccepted, InviteAcceptedDate, InviteDeclined, InviteDeclinedDate,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM EventInvites
	WHERE Deleted = 0
	AND EventID = @EventID
	ORDER BY EmailAddress
END
GO

/*===============================================================
// Function: spUpdateEventInvite
// Description:
//   Update event invite
//=============================================================*/
PRINT 'Creating spUpdateEventInvite...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateEventInvite')
BEGIN
	DROP Procedure spUpdateEventInvite
END
GO

CREATE Procedure spUpdateEventInvite
	@EventInviteID					int,
	@UserID							int,
	@EmailAddress					nvarchar(200),
	@InviteAdditionalText			nvarchar(max),
	@InviteEmailSent				bit,
	@InviteEmailSentEmailAddress	nvarchar(200),
	@InviteEmailSentDate			datetime,
	@InviteAccepted					bit,
	@InviteAcceptedDate				datetime,
	@InviteDeclined					bit,
	@InviteDeclinedDate				datetime,
	@LastUpdatedDate				datetime,
	@LastUpdatedByFullName			nvarchar(200)
AS
BEGIN
	UPDATE EventInvites
	SET EmailAddress					= @EmailAddress,
		UserID							= @UserID,
		InviteAdditionalText			= @InviteAdditionalText,
		InviteEmailSent					= @InviteEmailSent,
		InviteEmailSentEmailAddress		= @InviteEmailSentEmailAddress,
		InviteEmailSentDate				= @InviteEmailSentDate,
		InviteAccepted					= @InviteAccepted,
		InviteAcceptedDate				= @InviteAcceptedDate,
		InviteDeclined					= @InviteDeclined,
		InviteDeclinedDate				= @InviteDeclinedDate,
		LastUpdatedDate					= @LastUpdatedDate,
		LastUpdatedByFullName			= @LastUpdatedByFullName
	WHERE EventInviteID = @EventInviteID
END
GO

/*===============================================================
// Function: spDeleteEventInvite
// Description:
//   Delete event invite
//=============================================================*/
PRINT 'Creating spDeleteEventInvite...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteEventInvite')
BEGIN
	DROP Procedure spDeleteEventInvite
END
GO

CREATE Procedure spDeleteEventInvite
	@EventInviteID				int,
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200)
AS
BEGIN
	UPDATE EventInvites
	SET Deleted					= 1,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE EventInviteID = @EventInviteID
END
GO

/*===============================================================
// Function: spSelectEventInviteCountByEventID
// Description:
//   Selects the tracked events for a user
//=============================================================*/
PRINT 'Creating spSelectEventInviteCountByEventID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventInviteCountByEventID')
BEGIN
	DROP Procedure spSelectEventInviteCountByEventID
END
GO

CREATE Procedure spSelectEventInviteCountByEventID
	@EventID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM EventInvites I
	JOIN Events E
	ON I.EventID = E.EventID
	WHERE I.EventID = @EventID
	AND E.Deleted = 0
	AND I.Deleted = 0
	
END
GO

/*===============================================================
// Function: spSelectPendingEventInviteCountByEventID
// Description:
//   Selects the tracked events for a user
//=============================================================*/
PRINT 'Creating spSelectPendingEventInviteCountByEventID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectPendingEventInviteCountByEventID')
BEGIN
	DROP Procedure spSelectPendingEventInviteCountByEventID
END
GO

CREATE Procedure spSelectPendingEventInviteCountByEventID
	@EventID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM EventInvites I
	JOIN Events E
	ON I.EventID = E.EventID
	WHERE I.EventID = @EventID
	AND E.Deleted = 0
	AND I.Deleted = 0
	AND I.InviteAccepted = 0
	AND I.InviteDeclined = 0
	
END
GO

/*===============================================================
// Function: spSelectEventInviteCountByEventIDAndEmailAddress
// Description:
//   Used to check if a particular email address has already
//	 been invited to a specific event
//=============================================================*/
PRINT 'Creating spSelectEventInviteCountByEventIDAndEmailAddress...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventInviteCountByEventIDAndEmailAddress')
BEGIN
	DROP Procedure spSelectEventInviteCountByEventIDAndEmailAddress
END
GO

CREATE Procedure spSelectEventInviteCountByEventIDAndEmailAddress
	@EventID						int,
	@InviteEmailSentEmailAddress	nvarchar(200)
AS
BEGIN
	SELECT COUNT(*)
	FROM EventInvites
	WHERE EventID = @EventID
	AND Deleted = 0
	AND EmailAddress = @InviteEmailSentEmailAddress
	
END
GO

/*===============================================================
// Function: spSelectPendingInviteCountForUser
// Description:
//=============================================================*/
PRINT 'Creating spSelectPendingInviteCountForUser...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectPendingInviteCountForUser')
BEGIN
	DROP Procedure spSelectPendingInviteCountForUser
END
GO

CREATE Procedure spSelectPendingInviteCountForUser
	@UserID			int,
	@EmailAddress	nvarchar(200)
AS
BEGIN
	SELECT COUNT(*)
	FROM EventInvites I
	JOIN Events E
	ON I.EventID = E.EventID
	JOIN Users U
	ON U.UserID = E.UserID
	WHERE I.Deleted = 0
	AND E.Deleted = 0
	AND ( I.UserID = @UserID
		OR (I.UserID IS NULL AND I.EmailAddress = @EmailAddress) )
	AND I.InviteAccepted = 0
	AND I.InviteDeclined = 0
	
END
GO

/*===============================================================
// Function: spCheckUserEventInviteExists
// Description:
//=============================================================*/
PRINT 'Creating spCheckUserEventInviteExists...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCheckUserEventInviteExists')
BEGIN
	DROP Procedure spCheckUserEventInviteExists
END
GO

CREATE Procedure spCheckUserEventInviteExists
	@EventID					int,
	@UserID						int
AS
BEGIN
	SELECT COUNT(*)
	FROM EventInvites
	WHERE UserID = @UserID
	AND EventID = @EventID
	AND Deleted = 0
	AND InviteAccepted = 0
	AND InviteDeclined = 0
	
END
GO

/*===============================================================
// Function: spGetEventInviteIDFromUserIDEventID
// Description:
//=============================================================*/
PRINT 'Creating spGetEventInviteIDFromUserIDEventID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetEventInviteIDFromUserIDEventID')
BEGIN
	DROP Procedure spGetEventInviteIDFromUserIDEventID
END
GO

CREATE Procedure spGetEventInviteIDFromUserIDEventID
	@EventID					int,
	@UserID						int
AS
BEGIN
	SELECT EventInviteID
	FROM EventInvites
	WHERE UserID = @UserID
	AND EventID = @EventID
	AND Deleted = 0
	AND InviteAccepted = 0
	AND InviteDeclined = 0
	
END
GO

/*===============================================================
// Function: spSelectPendingInviteListForUser
// Description:
//   Selects the users pending invites
//=============================================================*/
PRINT 'Creating spSelectPendingInviteListForUser...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectPendingInviteListForUser')
BEGIN
	DROP Procedure spSelectPendingInviteListForUser
END
GO

CREATE Procedure spSelectPendingInviteListForUser
	@UserID			int,
	@EmailAddress	nvarchar(200)
AS
BEGIN
	SELECT I.EventInviteID, I.GUID, I.EventID, I.EmailAddress, I.InviteAdditionalText, 
		I.InviteEmailSent, I.InviteEmailSentEmailAddress, I.InviteEmailSentDate,
		I.InviteAccepted, I.InviteAcceptedDate, I.InviteDeclined, I.InviteDeclinedDate,
		I.CreatedDate, I.CreatedByFullName, I.LastUpdatedDate, I.LastUpdatedByFullName,
		E.EventName, E.EventDescription, E.EventVenue, E.MustDo, E.DateType,
		E.StartDate, E.RangeStartDate, E.RangeEndDate, E.BeforeBirthday,
		E.CategoryID, E.TimezoneID, E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		U.EmailAddress, U.FirstName, U.LastName, U.Gender, U.HomeTown,
		U.Birthday, U.ProfilePicFilename, U.ProfilePicThumbnail, U.ProfilePicPreview,
		U.ProfileText
	FROM EventInvites I
	JOIN Events E
	ON I.EventID = E.EventID
	JOIN Users U
	ON U.UserID = E.UserID
	WHERE I.Deleted = 0
	AND E.Deleted = 0
	AND ( I.UserID = @UserID
		OR (I.UserID IS NULL AND I.EmailAddress = @EmailAddress) )
	AND I.InviteAccepted = 0
	AND I.InviteDeclined = 0
	ORDER BY I.CreatedDate
	
END
GO

/*===============================================================
// Function: spSelectEventInviteIDFromGUID
// Description:
//=============================================================*/
PRINT 'Creating spSelectEventInviteIDFromGUID...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventInviteIDFromGUID')
BEGIN
	DROP Procedure spSelectEventInviteIDFromGUID
END
GO

CREATE Procedure spSelectEventInviteIDFromGUID
	@GUID		nvarchar(50)
AS
BEGIN
	SELECT EventInviteID
	FROM EventInvites
	WHERE GUID = @GUID
	AND Deleted = 0
	
END
GO

/*===============================================================
// Function: spAddEventAlert
// Description:
//   Add an event alert to the database
//=============================================================*/
PRINT 'Creating spAddEventAlert...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddEventAlert')
	BEGIN
		DROP Procedure spAddEventAlert
	END
GO

CREATE Procedure spAddEventAlert
	@EventID				int,
	@AlertDate				datetime,
	@AlertText				nvarchar(max),
	@CreatedDate			datetime,
	@CreatedByFullName		nvarchar(200),
	@LastUpdatedDate		datetime,
	@LastUpdatedByFullName	nvarchar(200),
	@EventAlertID			int OUTPUT
AS
BEGIN
	INSERT INTO EventAlerts
	(
		EventID,
		AlertDate,
		AlertText,
		Completed,
		Deleted,
		ReminderEmailSent,
		CreatedDate,
		CreatedByFullName,
		LastUpdatedDate,
		LastUpdatedByFullName
	)
	VALUES
	(
		@EventID,
		@AlertDate,
		@AlertText,
		0,		-- Completed
		0,		-- Deleted
		0,		-- ReminderEmailSent
		@CreatedDate,
		@CreatedByFullName,
		@LastUpdatedDate,
		@LastUpdatedByFullName
	)
	
	SET @EventAlertID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectEventAlertDetails
// Description:
//   Gets event alert details
//=============================================================*/
PRINT 'Creating spSelectEventAlertDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventAlertDetails')
BEGIN
	DROP Procedure spSelectEventAlertDetails
END
GO

CREATE Procedure spSelectEventAlertDetails
	@EventAlertID			int
AS
BEGIN
	SELECT EventID, AlertDate, AlertText, Completed, Deleted, ReminderEmailSent,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM EventAlerts
	WHERE EventAlertID = @EventAlertID
END
GO

/*===============================================================
// Function: spSelectEventAlertList
// Description:
//   Selects the events alerts
//=============================================================*/
PRINT 'Creating spSelectEventAlertList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventAlertList')
BEGIN
	DROP Procedure spSelectEventAlertList
END
GO

CREATE Procedure spSelectEventAlertList
	@EventID		int
AS
BEGIN
	SELECT A.EventAlertID, A.AlertDate, A.AlertText, A.Completed,
		A.CreatedDate, A.CreatedByFullName, A.LastUpdatedDate, A.LastUpdatedByFullName
	FROM EventAlerts A
	JOIN Events E
	ON A.EventID = E.EventID
	WHERE A.Completed = 0
	AND A.Deleted = 0
	AND E.Deleted = 0
	AND A.EventID = @EventID
	ORDER BY A.CreatedDate DESC
END
GO

/*===============================================================
// Function: spSelectEventAlertListPending
// Description:
//   Selects the events alerts
//=============================================================*/
PRINT 'Creating spSelectEventAlertListPending...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventAlertListPending')
BEGIN
	DROP Procedure spSelectEventAlertListPending
END
GO

CREATE Procedure spSelectEventAlertListPending
	@EventID		int
AS
BEGIN
	SELECT A.EventAlertID, A.AlertDate, A.AlertText, 
		A.CreatedDate, A.CreatedByFullName, A.LastUpdatedDate, A.LastUpdatedByFullName
	FROM EventAlerts A
	JOIN Events E
	ON A.EventID = E.EventID
	WHERE A.Completed = 0
	AND A.Deleted = 0
	AND E.Deleted = 0
	AND A.EventID = @EventID
	ORDER BY A.CreatedDate DESC
END
GO

/*===============================================================
// Function: spSelectEventAlertListPendingByUser
// Description:
//   Selects the events alerts
//=============================================================*/
PRINT 'Creating spSelectEventAlertListPendingByUser...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventAlertListPendingByUser')
BEGIN
	DROP Procedure spSelectEventAlertListPendingByUser
END
GO

CREATE Procedure spSelectEventAlertListPendingByUser
	@UserID		int
AS
BEGIN
	SELECT A.EventAlertID, A.EventID, A.AlertDate, A.AlertText, 
		A.CreatedDate, A.CreatedByFullName, A.LastUpdatedDate, A.LastUpdatedByFullName,
		E.EventName, E.EventDescription, E.EventVenue, E.MustDo, E.DateType,
		E.StartDate, E.RangeStartDate, E.RangeEndDate, E.BeforeBirthday,
		E.CategoryID, E.TimezoneID, E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview
	FROM EventAlerts A
	JOIN Events E
	ON A.EventID = E.EventID
	WHERE A.Completed = 0
	AND A.Deleted = 0
	AND E.Deleted = 0
	AND E.UserID = @UserID
	ORDER BY A.CreatedDate DESC
END
GO

/*===============================================================
// Function: spSelectEventAlertCountPending
// Description:
//   Selects the number of events alerts
//=============================================================*/
PRINT 'Creating spSelectEventAlertCountPending...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventAlertCountPending')
BEGIN
	DROP Procedure spSelectEventAlertCountPending
END
GO

CREATE Procedure spSelectEventAlertCountPending
	@EventID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM EventAlerts A
	JOIN Events E
	ON A.EventID = E.EventID
	WHERE A.Completed = 0
	AND A.Deleted = 0
	AND E.Deleted = 0
	AND A.EventID = @EventID
END
GO

/*===============================================================
// Function: spSelectEventAlertCountPendingByUser
// Description:
//   Selects the number of events alerts
//=============================================================*/
PRINT 'Creating spSelectEventAlertCountPendingByUser...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventAlertCountPendingByUser')
BEGIN
	DROP Procedure spSelectEventAlertCountPendingByUser
END
GO

CREATE Procedure spSelectEventAlertCountPendingByUser
	@UserID		int
AS
BEGIN
	SELECT COUNT(*)
	FROM EventAlerts A
	JOIN Events E
	ON A.EventID = E.EventID
	WHERE A.Completed = 0
	AND A.Deleted = 0
	AND E.Deleted = 0
	AND E.UserID = @UserID
END
GO

/*===============================================================
// Function: spUpdateEventAlert
// Description:
//   Update event alert
//=============================================================*/
PRINT 'Creating spUpdateEventAlert...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateEventAlert')
BEGIN
	DROP Procedure spUpdateEventAlert
END
GO

CREATE Procedure spUpdateEventAlert
	@EventAlertID				int,
	@AlertDate					datetime,
	@AlertText					nvarchar(max),
	@Completed					bit,
	@ReminderEmailSent			bit,
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200)
AS
BEGIN
	UPDATE EventAlerts
	SET AlertText				= @AlertText,
		AlertDate				= @AlertDate,
		Completed				= @Completed,
		ReminderEmailSent		= @ReminderEmailSent,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE EventAlertID = @EventAlertID
END
GO

/*===============================================================
// Function: spDeleteEventAlert
// Description:
//   Delete event alert
//=============================================================*/
PRINT 'Creating spDeleteEventAlert...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteEventAlert')
BEGIN
	DROP Procedure spDeleteEventAlert
END
GO

CREATE Procedure spDeleteEventAlert
	@EventAlertID				int,
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200)
AS
BEGIN
	UPDATE EventAlerts
	SET Deleted					= 1,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE EventAlertID = @EventAlertID
END
GO

/*===============================================================
// Function: spSelectLatestEvents
// Description:
//   Gets most recent events
//=============================================================*/
PRINT 'Creating spSelectLatestEvents...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectLatestEvents')
BEGIN
	DROP Procedure spSelectLatestEvents
END
GO

CREATE Procedure spSelectLatestEvents
AS
BEGIN
	SELECT TOP 4 EventID, UserID, EventName, EventVenue, DateType,
		StartDate, RangeStartDate, RangeEndDate, BeforeBirthday,
		EventAchieved, EventAchievedDate,
		CategoryID, TimezoneID, EventPicFilename, EventPicThumbnail, EventPicPreview
	FROM Events
	WHERE Deleted = 0
	AND PrivateEvent = 0
	AND EventAchieved = 0
	ORDER BY CreatedDate DESC
	
END
GO

/*===============================================================
// Function: spSelectLatestEventsDefaultPage
// Description:
//   Gets most recent events
//=============================================================*/
PRINT 'Creating spSelectLatestEventsDefaultPage...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectLatestEventsDefaultPage')
BEGIN
	DROP Procedure spSelectLatestEventsDefaultPage
END
GO

CREATE Procedure spSelectLatestEventsDefaultPage
AS
BEGIN
	SELECT TOP 10 EventID, UserID, EventName, EventVenue, DateType,
		StartDate, RangeStartDate, RangeEndDate, BeforeBirthday,
		EventAchieved, EventAchievedDate,
		CategoryID, TimezoneID, EventPicFilename, EventPicThumbnail, EventPicPreview
	FROM Events
	WHERE Deleted = 0
	AND PrivateEvent = 0
	AND EventAchieved = 0
	ORDER BY LastUpdatedDate DESC
	
END
GO

/*===============================================================
// Function: spSelectLatestUpdatedEvents
// Description:
//   Gets most recent events
//=============================================================*/
PRINT 'Creating spSelectLatestUpdatedEvents...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectLatestUpdatedEvents')
BEGIN
	DROP Procedure spSelectLatestUpdatedEvents
END
GO

CREATE Procedure spSelectLatestUpdatedEvents
AS
BEGIN
	SELECT TOP 4 EventID, UserID, EventName, EventVenue, DateType,
		StartDate, RangeStartDate, RangeEndDate, BeforeBirthday,
		EventAchieved, EventAchievedDate,
		CategoryID, TimezoneID, EventPicFilename, EventPicThumbnail, EventPicPreview
	FROM Events
	WHERE Deleted = 0
	AND PrivateEvent = 0
	AND EventAchieved = 0
	AND CreatedDate <> LastUpdatedDate
	ORDER BY LastUpdatedDate DESC
	
END
GO

/*===============================================================
// Function: spSelectHappeningNowEvents
// Description:
//   Gets most recent events
//=============================================================*/
PRINT 'Creating spSelectHappeningNowEvents...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectHappeningNowEvents')
BEGIN
	DROP Procedure spSelectHappeningNowEvents
END
GO

CREATE Procedure spSelectHappeningNowEvents
AS
BEGIN
	SELECT TOP 4 EventID, UserID, EventName, EventVenue, DateType,
		StartDate, RangeStartDate, RangeEndDate, BeforeBirthday,
		EventAchieved, EventAchievedDate,
		CategoryID, TimezoneID, EventPicFilename, EventPicThumbnail, EventPicPreview
	FROM Events
	WHERE Deleted = 0
	AND PrivateEvent = 0
	AND EventAchieved = 0
    AND ( ( RangeStartDate <= getdate() AND RangeEndDate >= getdate() )
       OR convert(varchar(10),StartDate,103) = convert(varchar(10),getdate(),103) )
	ORDER BY StartDate DESC, RangeEndDate ASC
	
END
GO

/*===============================================================
// Function: spSelectLatestAchievedEvents
// Description:
//   Gets most achieved events
//=============================================================*/
PRINT 'Creating spSelectLatestAchievedEvents...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectLatestAchievedEvents')
BEGIN
	DROP Procedure spSelectLatestAchievedEvents
END
GO

CREATE Procedure spSelectLatestAchievedEvents
AS
BEGIN
	SELECT TOP 4 EventID, UserID, EventName, EventVenue, DateType,
		StartDate, RangeStartDate, RangeEndDate, BeforeBirthday,
		EventAchieved, EventAchievedDate,
		CategoryID, TimezoneID, EventPicFilename, EventPicThumbnail, EventPicPreview
	FROM Events
	WHERE Deleted = 0
	AND PrivateEvent = 0
	AND EventAchieved = 1
	order by EventAchievedDate desc
	
END
GO


/*===============================================================
// Function: spSelectLatestAchievedEventsFullList
// Description:
//   Gets most achieved events
//=============================================================*/
PRINT 'Creating spSelectLatestAchievedEventsFullList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectLatestAchievedEventsFullList')
BEGIN
	DROP Procedure spSelectLatestAchievedEventsFullList
END
GO

CREATE Procedure spSelectLatestAchievedEventsFullList
AS
BEGIN
	SELECT TOP 20 EventID, UserID, EventName, EventVenue, DateType,
		StartDate, RangeStartDate, RangeEndDate, BeforeBirthday,
		EventAchieved, EventAchievedDate,
		CategoryID, TimezoneID, EventPicFilename, EventPicThumbnail, EventPicPreview
	FROM Events
	WHERE Deleted = 0
	AND PrivateEvent = 0
	AND EventAchieved = 1
	order by EventAchievedDate desc
	
END
GO

/*===============================================================
// Function: spSelectAlertsToSendByEmail
// Description:
//   
//=============================================================*/
PRINT 'Creating spSelectAlertsToSendByEmail...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectAlertsToSendByEmail')
BEGIN
	DROP Procedure spSelectAlertsToSendByEmail
END
GO

CREATE Procedure spSelectAlertsToSendByEmail
AS
BEGIN
	SELECT EventAlertID, EventAlertGUID, EventID, AlertDate, AlertText
	FROM EventAlerts
	WHERE AlertDate < getdate()
	AND Completed = 0
	AND Deleted = 0
	AND ReminderEmailSent = 0
	
END
GO

/*===============================================================
// Function: spSelectEventListByFirstLetter
// Description:
//   Selects the event list
//=============================================================*/
PRINT 'Creating spSelectEventListByFirstLetter...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventListByFirstLetter')
BEGIN
	DROP Procedure spSelectEventListByFirstLetter
END
GO

CREATE Procedure spSelectEventListByFirstLetter
	@LetterFilter	char(1)
AS
BEGIN
	SELECT EventID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,
		EventDescription, EventVenue, MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM Events
	WHERE PrivateEvent = 0
	AND EventAchieved = 0
	AND Deleted = 0
	AND SUBSTRING(EventName, 1, 1) = @LetterFilter
	ORDER BY StartDate
END
GO

/*===============================================================
// Function: spSelectEventPictureDetails
// Description:
//   Gets picture details
// --------------------------------------------------------------
// Parameters
//	 @EventID			int
//=============================================================*/
PRINT 'Creating spSelectEventPictureDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventPictureDetails')
BEGIN
	DROP Procedure spSelectEventPictureDetails
END
GO

CREATE Procedure spSelectEventPictureDetails
	@EventPictureID		int
AS
BEGIN
	SELECT EventID, PostedByUserID, ImageFilename, ImagePreview, 
		ImageThumbnail, Deleted, Caption,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM EventPictures
	WHERE EventPictureID = @EventPictureID
END
GO

/*===============================================================
// Function: spSelectEventPictureList
// Description:
//   Selects the list of pictures
//=============================================================*/
PRINT 'Creating spSelectEventPictureList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventPictureList')
BEGIN
	DROP Procedure spSelectEventPictureList
END
GO

CREATE Procedure spSelectEventPictureList
	@EventID		int
AS
BEGIN
	SELECT EventPictureID, EventID, PostedByUserID, ImageFilename, ImagePreview, 
		ImageThumbnail, Deleted, Caption,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM EventPictures
	WHERE EventID = @EventID
	AND Deleted = 0
	ORDER BY EventPictureID
END
GO

/*===============================================================
// Function: spSelectEventPictureListTop18
// Description:
//   Selects the list of pictures
//=============================================================*/
PRINT 'Creating spSelectEventPictureListTop18...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventPictureListTop18')
BEGIN
	DROP Procedure spSelectEventPictureListTop18
END
GO

CREATE Procedure spSelectEventPictureListTop18
	@EventID		int
AS
BEGIN
	SELECT TOP 18 EventPictureID, EventID, PostedByUserID, ImageFilename, ImagePreview, 
		ImageThumbnail, Deleted, Caption,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName
	FROM EventPictures
	WHERE EventID = @EventID
	AND Deleted = 0
	ORDER BY EventPictureID
END
GO

/*===============================================================
// Function: spSelectEventPicturePrevious
// Description:
//=============================================================*/
PRINT 'Creating spSelectEventPicturePrevious...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventPicturePrevious')
BEGIN
	DROP Procedure spSelectEventPicturePrevious
END
GO

CREATE Procedure spSelectEventPicturePrevious
	@EventID			int,
	@EventPictureID		int
AS
BEGIN
	SELECT MAX(EventPictureID)
	FROM EventPictures
	WHERE EventID = @EventID
	AND EventPictureID < @EventPictureID
	AND Deleted = 0
END
GO

/*===============================================================
// Function: spSelectEventPictureNext
// Description:
//=============================================================*/
PRINT 'Creating spSelectEventPictureNext...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventPictureNext')
BEGIN
	DROP Procedure spSelectEventPictureNext
END
GO

CREATE Procedure spSelectEventPictureNext
	@EventID			int,
	@EventPictureID		int
AS
BEGIN
	SELECT MIN(EventPictureID)
	FROM EventPictures
	WHERE EventID = @EventID
	AND EventPictureID > @EventPictureID
	AND Deleted = 0
END
GO

/*===============================================================
// Function: spSelectEventPictureFirst
// Description:
//=============================================================*/
PRINT 'Creating spSelectEventPictureFirst...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventPictureFirst')
BEGIN
	DROP Procedure spSelectEventPictureFirst
END
GO

CREATE Procedure spSelectEventPictureFirst
	@EventID			int
AS
BEGIN
	SELECT MIN(EventPictureID)
	FROM EventPictures
	WHERE EventID = @EventID
	AND Deleted = 0
END
GO

/*===============================================================
// Function: spSelectEventPictureLast
// Description:
//=============================================================*/
PRINT 'Creating spSelectEventPictureLast...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventPictureLast')
BEGIN
	DROP Procedure spSelectEventPictureLast
END
GO

CREATE Procedure spSelectEventPictureLast
	@EventID			int
AS
BEGIN
	SELECT MAX(EventPictureID)
	FROM EventPictures
	WHERE EventID = @EventID
	AND Deleted = 0
END
GO

/*===============================================================
// Function: spAddEventPicture
// Description:
//   Add a picture
//=============================================================*/
PRINT 'Creating spAddEventPicture...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddEventPicture')
	BEGIN
		DROP Procedure spAddEventPicture
	END
GO

CREATE Procedure spAddEventPicture
	@EventID					int,
	@PostedByUserID				int,
	@ImageFilename				nvarchar(200),
	@ImageThumbnail				nvarchar(200),
	@ImagePreview				nvarchar(200),
	@Caption					nvarchar(500),
	@CreatedDate				datetime,
	@CreatedByFullName			nvarchar(200),
	@LastUpdatedDate			datetime,
	@LastUpdatedByFullName		nvarchar(200),
	@EventPictureID				int OUTPUT
AS
BEGIN
	INSERT INTO EventPictures
	(
		EventID,
		PostedByUserID,
		ImageFilename,
		ImageThumbnail,
		ImagePreview,
		Caption,
		Deleted,
		CreatedDate,
		CreatedByFullName,
		LastUpdatedDate,
		LastUpdatedByFullName
	)
	VALUES
	(
		@EventID,
		@PostedByUserID,
		@ImageFilename,
		@ImageThumbnail,
		@ImagePreview,
		@Caption,
		0,		-- Deleted
		@CreatedDate,
		@CreatedByFullName,
		@LastUpdatedDate,
		@LastUpdatedByFullName
	)
	
	SET @EventPictureID = @@IDENTITY
END
GO

/*===============================================================
// Function: spUpdateEventPicture
// Description:
//   Update event details
//=============================================================*/
PRINT 'Creating spUpdateEventPicture...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateEventPicture')
BEGIN
	DROP Procedure spUpdateEventPicture
END
GO

CREATE Procedure spUpdateEventPicture
	@EventPictureID					int,
	@ImageFilename					nvarchar(200),
	@ImageThumbnail					nvarchar(200),
	@ImagePreview					nvarchar(200),
	@Caption						nvarchar(500),
	@LastUpdatedDate				datetime,
	@LastUpdatedByFullName			nvarchar(200)
AS
BEGIN
	UPDATE EventPictures
	SET ImageFilename			= @ImageFilename,
		ImageThumbnail			= @ImageThumbnail,
		ImagePreview			= @ImagePreview,
		Caption					= @Caption,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE EventPictureID = @EventPictureID
END
GO

/*===============================================================
// Function: spDeleteEventPicture
// Description:
//   Delete event picture
//=============================================================*/
PRINT 'Creating spDeleteEventPicture...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteEventPicture')
BEGIN
	DROP Procedure spDeleteEventPicture
END
GO

CREATE Procedure spDeleteEventPicture
	@EventPictureID					int,
	@LastUpdatedDate				datetime,
	@LastUpdatedByFullName			nvarchar(200)
AS
BEGIN
	UPDATE EventPictures
	SET Deleted					= 1,
		LastUpdatedDate			= @LastUpdatedDate,
		LastUpdatedByFullName	= @LastUpdatedByFullName
	WHERE EventPictureID = @EventPictureID
END
GO

/*===============================================================
// Function: spSelectEventsWithPicturesList
// Description:
//   Selects the list of pictures
//=============================================================*/
PRINT 'Creating spSelectEventsWithPicturesList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectEventsWithPicturesList')
BEGIN
	DROP Procedure spSelectEventsWithPicturesList
END
GO

CREATE Procedure spSelectEventsWithPicturesList
	@UserID		int
AS
BEGIN
	SELECT DISTINCT(P.EventID) AS EventID
	FROM EventPictures P
	JOIN Events E
	ON P.EventID = E.EventID
	WHERE UserID = @UserID
	AND E.Deleted = 0
	AND P.Deleted = 0
	
END
GO


-- =============================================
-- Author:		Nikita Knyazev
-- Create date: 21.07.2010
-- Description:	search procedure that uses only text. The number of results is limited
-- =============================================
PRINT 'Creating spSearchLimitedEvents...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSearchLimitedEvents')
BEGIN
	DROP Procedure spSearchLimitedEvents
END
GO


CREATE PROCEDURE [dbo].[spSearchLimitedEvents] 
	@SearchText nvarchar(100),
	@Start int = 0,
	@Count int = 10
as
BEGIN
	SET NOCOUNT ON;
	
	select EventID, UserID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName,
		EmailAddress, FirstName, LastName, Gender, HomeTown, ProfilePicThumbnail
	 from(
		select ROW_NUMBER() over (order by StartDate) as rn, 
		E.EventID, E.UserID, E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate,
		E.BeforeBirthday, E.CategoryID, E.TimezoneID, E.EventAchieved, E.EventAchievedDate,
		E.PrivateEvent, E.CreatedFromEventID,E.MustDo,
		E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		E.CreatedDate, E.CreatedByFullName, E.LastUpdatedDate, E.LastUpdatedByFullName,
		U.EmailAddress, U.FirstName, U.LastName, U.Gender, U.HomeTown, U.ProfilePicThumbnail
		FROM Events E
		JOIN Users U
		ON E.UserID = U.UserID
		WHERE E.Deleted = 0
		AND E.EventAchieved = 0
		AND E.PrivateEvent = 0
		AND ( (@SearchText is null or @SearchText = '') 
		 OR (UPPER(E.EventName) LIKE '%'+UPPER(@SearchText)+'%')
		 OR (UPPER(U.FirstName) + ' ' + UPPER(U.LastName) LIKE '%'+UPPER(@SearchText)+'%') ) 
		 
		
		
	
	) as t where t.rn BETWEEN (isnull(@Start,0)+1) AND (isnull(@Start,0) + isnull(@Count, 10))
	--ORDER BY t.Coords.STDistance(@point) asc
    ORDER BY StartDate
    
END

GO


-- =============================================
-- Author:		Nikita Knyazev
-- Create date: 21.07.2010
-- Description:	search procedure that returns a limited amount of random events
-- =============================================
PRINT 'Creating spSearchLimitedRandomEvents...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSearchLimitedRandomEvents')
BEGIN
	DROP Procedure spSearchLimitedRandomEvents
END
GO

CREATE PROCEDURE [dbo].[spSearchLimitedRandomEvents] 
	@Count int = 10
as
BEGIN
	SET NOCOUNT ON;
	
	select top (isnull(@Count,10)) 
		E.EventID, E.UserID, E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate,
		E.BeforeBirthday, E.CategoryID, E.TimezoneID, E.EventAchieved, E.EventAchievedDate,
		E.PrivateEvent, E.CreatedFromEventID,E.MustDo,
		E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		E.CreatedDate, E.CreatedByFullName, E.LastUpdatedDate, E.LastUpdatedByFullName,
		U.EmailAddress, U.FirstName, U.LastName, U.Gender, U.HomeTown, U.ProfilePicThumbnail
		FROM Events E
		JOIN Users U
		ON E.UserID = U.UserID
		WHERE E.Deleted = 0
		AND E.EventAchieved = 0
		AND E.PrivateEvent = 0
		
		
	
	--ORDER BY t.Coords.STDistance(@point) asc
    ORDER BY NEWID(), StartDate
    
END

GO

-- =============================================
-- Author:		Nikita Knyazev
-- Create date: 21.07.2010
-- Description:	search procedure that uses location
-- =============================================
PRINT 'Creating spSearchEventsByLocation...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSearchEventsByLocation')
BEGIN
	DROP Procedure spSearchEventsByLocation
END
GO


CREATE PROCEDURE [dbo].[spSearchEventsByLocation] 
	@SearchText nvarchar(100),
	@Latitude float,
	@Longitude float,
	@RadiusInMeters int, --Radius in meters!
	@Start int =  0,
	@Count int = 10
as
BEGIN
	SET NOCOUNT ON;
	select EventID, UserID, EventName, DateType, StartDate, RangeStartDate, RangeEndDate,
		BeforeBirthday, CategoryID, TimezoneID, EventAchieved, EventAchievedDate,
		PrivateEvent, CreatedFromEventID,MustDo,
		EventPicFilename, EventPicThumbnail, EventPicPreview,
		CreatedDate, CreatedByFullName, LastUpdatedDate, LastUpdatedByFullName,
		EmailAddress, FirstName, LastName, Gender, HomeTown, ProfilePicThumbnail
	 from(
		select ROW_NUMBER() over (order by StartDate) as rn, 
		E.EventID, E.UserID, E.EventName, E.DateType, E.StartDate, E.RangeStartDate, E.RangeEndDate,
		E.BeforeBirthday, E.CategoryID, E.TimezoneID, E.EventAchieved, E.EventAchievedDate,
		E.PrivateEvent, E.CreatedFromEventID,E.MustDo,
		E.EventPicFilename, E.EventPicThumbnail, E.EventPicPreview,
		E.CreatedDate, E.CreatedByFullName, E.LastUpdatedDate, E.LastUpdatedByFullName,
		U.EmailAddress, U.FirstName, U.LastName, U.Gender, U.HomeTown, U.ProfilePicThumbnail
		FROM Events E
		JOIN Users U
		ON E.UserID = U.UserID
		WHERE E.Deleted = 0
		AND E.EventAchieved = 0
		AND E.PrivateEvent = 0
		AND ( (@SearchText is null or @SearchText = '') 
		 OR (UPPER(E.EventName) LIKE '%'+UPPER(@SearchText)+'%')
		 OR (UPPER(U.FirstName) + ' ' + UPPER(U.LastName) LIKE '%'+UPPER(@SearchText)+'%') ) 
		 
		and Geography::Point(@Latitude, @Longitude, 4326).STBuffer(@RadiusInMeters).STIntersects(e.Coords)=1 
		--STBuffer would create a x-meters buffer around @Radius then the STIntersects would return e.Coords points that fall within that x-meters radius.
		--SRID 4326 is the default and the one that is used by GPS systems.
	
		
		
	
	) as t where t.rn BETWEEN (isnull(@Start,0)+1) AND (isnull(@Start,0) + isnull(@Count, 10))
	--ORDER BY t.Coords.STDistance(@point) asc
    ORDER BY StartDate
    
END

GO



PRINT '== Finished createEventsStoredProcs.sql =='
GO
