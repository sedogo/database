/****** Object:  StoredProcedure [dbo].[spSelectSimilarEvents]    Script Date: 09/23/2010 04:43:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSelectSimilarEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spSelectSimilarEvents]
GO
/****** Object:  StoredProcedure [dbo].[spSelectSimilarEvents]    Script Date: 09/23/2010 04:43:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spSelectSimilarEvents]
	@SearchWord		nvarchar(50),
	@EventId		int
AS
BEGIN
	SELECT TOP 4 *
	FROM [Events]
	WHERE Deleted = 0  AND PrivateEvent = 0 	AND [Events].EventAchieved=0 
	AND FREETEXT(EventName, @SearchWord)  AND EventID != @EventId
	ORDER BY EventName ASC
END
GO