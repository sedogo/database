 /*===============================================================
// Filename: createSentEmailHistoryStoredProcs.sql
// Date: 22/02/10
// --------------------------------------------------------------
// Description:
//   This file creates the email history stored procedures
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 22/02/10
// Revision history:
//=============================================================*/

PRINT '== Starting createSentEmailHistoryStoredProcs.sql =='
GO

/*===============================================================
// Function: spAddSentEmailHistory
// Description:
//   Add an SentEmailHistory to the database
//=============================================================*/
PRINT 'Creating spAddSentEmailHistory...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddSentEmailHistory')
	BEGIN
		DROP Procedure spAddSentEmailHistory
	END
GO

CREATE Procedure spAddSentEmailHistory
	@SentFrom					nvarchar(200),
	@SentTo						nvarchar(200),
	@Subject					nvarchar(200),
	@Body						nvarchar(max),
	@SentDate					datetime,
	@LoggedInUserName			nvarchar(200),
	@SentEmailHistoryID			int OUTPUT
AS
BEGIN
	INSERT INTO SentEmailHistory
	(
		SentFrom,
		SentTo,
		Subject,
		Body,
		SentDate,
		LoggedInUserName
	)
	VALUES
	(
		@SentFrom,
		@SentTo,
		@Subject,
		@Body,
		@SentDate,
		@LoggedInUserName
	)
	
	SET @SentEmailHistoryID = @@IDENTITY
END
GO

PRINT '== Finished createSentEmailHistoryStoredProcs.sql =='
GO
 