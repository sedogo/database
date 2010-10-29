/*===============================================================
// Filename: createTimezoneStoredProcs.sql
// Date: 1/11/09
// --------------------------------------------------------------
// Description:
//   This file creates the timezone stored procedures
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 1/11/09
// Revision history:
//=============================================================*/

PRINT '== Starting createTimezoneStoredProcs.sql =='
GO
 
/*===============================================================
// Function: spAddTimezone
// Description:
//   Add a timezone to the database
//=============================================================*/
PRINT 'Creating spAddTimezone...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spAddTimezone')
	BEGIN
		DROP Procedure spAddTimezone
	END
GO

CREATE Procedure spAddTimezone
	@ShortCode			    nvarchar(10),
	@Description			nvarchar(200),
	@GMTOffset				int,
	@TimezoneID				int OUTPUT
AS
BEGIN
	INSERT INTO Timezones
	(
		ShortCode,
		Description,
		GMTOffset
	)
	VALUES
	(
		@ShortCode,
		@Description,
		@GMTOffset
	)
	
	SET @TimezoneID = @@IDENTITY
END
GO

/*===============================================================
// Function: spSelectTimezoneDetails
// Description:
//   Gets timezone details
// --------------------------------------------------------------
// Parameters
//	 @CountryID			int
//=============================================================*/
PRINT 'Creating spSelectTimezoneDetails...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectTimezoneDetails')
BEGIN
	DROP Procedure spSelectTimezoneDetails
END
GO

CREATE Procedure spSelectTimezoneDetails
	@TimezoneID			int
AS
BEGIN
	SELECT ShortCode, Description, GMTOffset
	FROM Timezones
	WHERE TimezoneID = @TimezoneID
END
GO

/*===============================================================
// Function: spSelectTimezoneList
// Description:
//   Selects the timezone list
//=============================================================*/
PRINT 'Creating spSelectTimezoneList...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spSelectTimezoneList')
BEGIN
	DROP Procedure spSelectTimezoneList
END
GO

CREATE Procedure spSelectTimezoneList
AS
BEGIN
	SELECT TimezoneID, ShortCode, Description, GMTOffset
	FROM Timezones
	ORDER BY GMTOffset
END
GO

/*===============================================================
// Function: spUpdateTimezone
// Description:
//   Update timezone
//=============================================================*/
PRINT 'Creating spUpdateTimezone...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spUpdateTimezone')
BEGIN
	DROP Procedure spUpdateTimezone
END
GO

CREATE Procedure spUpdateTimezone
	@TimezoneID				int,
	@ShortCode			    nvarchar(10),
	@Description			nvarchar(200),
	@GMTOffset				int
AS
BEGIN
	UPDATE Timezones
	SET ShortCode		= @ShortCode,
		Description		= @Description,
		GMTOffset		= @GMTOffset
	WHERE TimezoneID = @TimezoneID
END
GO

/*===============================================================
// Function: spDeleteTimezone
// Description:
//   Delete timezone
//=============================================================*/
PRINT 'Creating spDeleteTimezone...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spDeleteTimezone')
BEGIN
	DROP Procedure spDeleteTimezone
END
GO

CREATE Procedure spDeleteTimezone
	@TimezoneID				int,
	@ShortCode			    nvarchar(10),
	@Description			nvarchar(200),
	@GMTOffset				int
AS
BEGIN
	DELETE Timezones
	WHERE TimezoneID = @TimezoneID
END
GO

PRINT '== Finished createTiemzoneStoredProcs.sql =='
GO
 