/*===============================================================
// Filename: createHistoryTables.sql
// Date: 27/10/09
// --------------------------------------------------------------
// Description:
//   This file creates the history tables
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 27/10/09
// Revision history:
//=============================================================*/

PRINT '== Starting createHistoryTables.sql =='

/*===============================================================
// Table: SearchHistory
//=============================================================*/

PRINT 'Creating SearchHistory...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'SearchHistory')
	BEGIN
		DROP Table SearchHistory
	END
GO

CREATE TABLE SearchHistory
(
	SearchHistoryID					int					NOT NULL PRIMARY KEY IDENTITY,
	SearchDate						datetime		    NULL,
	UserID							int					NOT NULL,
	SearchText						nvarchar(200)		NOT NULL,
	SearchHits						int					NULL
)
GO

PRINT '== Finished createHistoryTables.sql =='
    