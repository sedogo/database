/****** Object:  StoredProcedure [dbo].[spSelectSimilarEvents]    Script Date: 12/03/2010 17:06:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spSelectSimilarEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spSelectSimilarEvents]
GO

/****** Object:  StoredProcedure [dbo].[spSelectSimilarEvents]    Script Date: 12/03/2010 17:06:43 ******/
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
	FROM [Events] e
	INNER JOIN FREETEXTTABLE([Events], EventName, @SearchWord) AS KEY_TBL 
		ON e.EventID = KEY_TBL.[KEY]
	WHERE Deleted = 0  AND e.PrivateEvent = 0 	
		AND e.EventAchieved=0 
		AND e.EventID != @EventId 
	ORDER BY KEY_TBL.RANK DESC
END

GO


