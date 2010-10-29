 /*===============================================================
// Filename: createHomePageContent.sql
// Date: 21/07/10
// --------------------------------------------------------------
// Description:
//   This file creates the HomePage table
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 21/07/10
// Revision history:
//=============================================================*/

PRINT '== Starting createHomePageContent.sql =='

/*===============================================================
// Table: HomePageContent
//=============================================================*/

PRINT 'Creating HomePageContent...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'HomePageContent')
	BEGIN
		DROP Table HomePageContent
	END
GO

CREATE TABLE HomePageContent
(
	HomePageContentID		int					NOT NULL PRIMARY KEY IDENTITY,
	HomePageContent			nvarchar(max)		NULL
)
GO

PRINT '== Finished createHomePageContent.sql =='
 