 /*===============================================================
// Filename: createSentEmailHistoryTables.sql
// Date: 22/02/10
// --------------------------------------------------------------
// Description:
//   This file creates the SentEmailHistory table
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 22/02/10
// Revision history:
//=============================================================*/

PRINT '== Starting createSentEmailHistoryTables.sql =='

/*===============================================================
// Table: SentEmailHistory
//=============================================================*/

PRINT 'Creating SentEmailHistory...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'SentEmailHistory')
	BEGIN
		DROP Table SentEmailHistory
	END
GO

CREATE TABLE SentEmailHistory
(
	SentEmailHistoryID				int					NOT NULL PRIMARY KEY IDENTITY,
	
	SentFrom						nvarchar(200)		NULL,
	SentTo							nvarchar(200)		NULL,
	Subject							nvarchar(200)		NULL,
	Body							nvarchar(max)		NULL,
	SentDate						datetime		    NULL,
	LoggedInUserName				nvarchar(200)	    NULL
)
GO

PRINT '== Finished createSentEmailHistoryTables.sql =='
  