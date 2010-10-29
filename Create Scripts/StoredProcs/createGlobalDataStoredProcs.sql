/*===============================================================
// Filename: createGlobalDataStoredProcs.sql
// Date: 10/07/09
// --------------------------------------------------------------
// Description:
//   This file creates the GlobalData stored procedures
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 10/07/09
// Revision history:
//=============================================================*/

PRINT '== Starting createGlobalDataStoredProcs.sql =='
GO

/*===============================================================
// Function: spGlobalDataAddIntegerValue
// Description:
//   Add an integer value to GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
//	 @Value					int
//=============================================================*/

PRINT 'Creating spGlobalDataAddIntegerValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataAddIntegerValue')
BEGIN
	DROP Procedure spGlobalDataAddIntegerValue
END
GO

CREATE Procedure spGlobalDataAddIntegerValue
	@KeyName			nvarchar(50),
	@Value				int
AS
BEGIN
	INSERT INTO GlobalData
	(
		KeyName,
		IntegerValue
	)
	VALUES
	(
		@KeyName,
		@Value
	)
END
GO

/*===============================================================
// Function: spGlobalDataAddNumericValue
// Description:
//   Add an numeric value to GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
//	 @Value					decimal(10,2)
//=============================================================*/

PRINT 'Creating spGlobalDataAddNumericValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataAddNumericValue')
BEGIN
	DROP Procedure spGlobalDataAddNumericValue
END
GO

CREATE Procedure spGlobalDataAddNumericValue
	@KeyName			nvarchar(50),
	@Value				decimal(10,2)
AS
BEGIN
	INSERT INTO GlobalData
	(
		KeyName,
		NumericValue
	)
	VALUES
	(
		@KeyName,
		@Value
	)
END
GO

/*===============================================================
// Function: spGlobalDataAddDateValue
// Description:
//   Add an datetime value to GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
//	 @Value					datetime
//=============================================================*/

PRINT 'Creating spGlobalDataAddDateValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataAddDateValue')
BEGIN
	DROP Procedure spGlobalDataAddDateValue
END
GO

CREATE Procedure spGlobalDataAddDateValue
	@KeyName			nvarchar(50),
	@Value				datetime
AS
BEGIN
	INSERT INTO GlobalData
	(
		KeyName,
		DateValue
	)
	VALUES
	(
		@KeyName,
		@Value
	)
END
GO

/*===============================================================
// Function: spGlobalDataAddStringValue
// Description:
//   Add an string value to GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
//	 @Value					nvarchar(1000)
//=============================================================*/

PRINT 'Creating spGlobalDataAddStringValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataAddStringValue')
BEGIN
	DROP Procedure spGlobalDataAddStringValue
END
GO

CREATE Procedure spGlobalDataAddStringValue
	@KeyName			nvarchar(50),
	@Value				nvarchar(1000)
AS
BEGIN
	INSERT INTO GlobalData
	(
		KeyName,
		StringValue
	)
	VALUES
	(
		@KeyName,
		@Value
	)
END
GO

/*===============================================================
// Function: spGlobalDataSelectIntegerValue
// Description:
//   Get an integer value from GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
// --------------------------------------------------------------
// Results
//	 Value
//=============================================================*/

PRINT 'Creating spGlobalDataSelectIntegerValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataSelectIntegerValue')
BEGIN
	DROP Procedure spGlobalDataSelectIntegerValue
END
GO

CREATE Procedure spGlobalDataSelectIntegerValue
	@KeyName			nvarchar(50)
AS
BEGIN
	SELECT IntegerValue
	FROM GlobalData
	WHERE KeyName = @KeyName
END
GO

/*===============================================================
// Function: spGlobalDataGetIntegerValue
// Description:
//   Get an integer value from GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
// --------------------------------------------------------------
// Results
//	 Value
//=============================================================*/

PRINT 'Creating spGlobalDataGetIntegerValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataGetIntegerValue')
BEGIN
	DROP Procedure spGlobalDataGetIntegerValue
END
GO

CREATE Procedure spGlobalDataGetIntegerValue
	@KeyName			nvarchar(50),
	@IntegerValue       int OUTPUT
AS
BEGIN
	SELECT @IntegerValue = IntegerValue
	FROM GlobalData
	WHERE KeyName = @KeyName
END
GO

/*===============================================================
// Function: spGlobalDataGetIntegerValueAndIncrement
// Description:
//   Get an integer value from GlobalData and increment it
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
// --------------------------------------------------------------
// Results
//	 Value
//=============================================================*/

PRINT 'Creating spGlobalDataGetIntegerValueAndIncrement...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataGetIntegerValueAndIncrement')
BEGIN
	DROP Procedure spGlobalDataGetIntegerValueAndIncrement
END
GO

CREATE Procedure spGlobalDataGetIntegerValueAndIncrement
	@KeyName			nvarchar(50),
	@IntegerValue       int OUTPUT
AS
BEGIN
    BEGIN TRAN
    
	SELECT @IntegerValue = IntegerValue
	FROM GlobalData (XLOCK)        -- (UPDLOCK)
	WHERE KeyName = @KeyName
	
	UPDATE GlobalData
	SET IntegerValue = IntegerValue+1
	WHERE KeyName = @KeyName
	
	COMMIT TRAN
END
GO

/*===============================================================
// Function: spGlobalDataGetNumericValue
// Description:
//   Get an numeric value from GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
// --------------------------------------------------------------
// Results
//	 Value
//=============================================================*/

PRINT 'Creating spGlobalDataGetNumericValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataGetNumericValue')
BEGIN
	DROP Procedure spGlobalDataGetNumericValue
END
GO

CREATE Procedure spGlobalDataGetNumericValue
	@KeyName			nvarchar(50)
AS
BEGIN
	SELECT NumericValue
	FROM GlobalData
	WHERE KeyName = @KeyName
END
GO

/*===============================================================
// Function: spGlobalDataGetDateValue
// Description:
//   Get an datetime value from GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
// --------------------------------------------------------------
// Results
//	 Value
//=============================================================*/

PRINT 'Creating spGlobalDataGetDateValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataGetDateValue')
BEGIN
	DROP Procedure spGlobalDataGetDateValue
END
GO

CREATE Procedure spGlobalDataGetDateValue
	@KeyName			nvarchar(50)
AS
BEGIN
	SELECT DateValue
	FROM GlobalData
	WHERE KeyName = @KeyName
END
GO

/*===============================================================
// Function: spGlobalDataGetStringValue
// Description:
//   Get an string value from GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
// --------------------------------------------------------------
// Results
//	 Value
//=============================================================*/

PRINT 'Creating spGlobalDataGetStringValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataGetStringValue')
BEGIN
	DROP Procedure spGlobalDataGetStringValue
END
GO

CREATE Procedure spGlobalDataGetStringValue
	@KeyName			nvarchar(50)
AS
BEGIN
	SELECT StringValue
	FROM GlobalData
	WHERE KeyName = @KeyName
END
GO

/*===============================================================
// Function: spGlobalDataGetStringValue2
// Description:
//   Get an string value from GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
// --------------------------------------------------------------
// Results
//	 Value
//=============================================================*/

PRINT 'Creating spGlobalDataGetStringValue2...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataGetStringValue2')
BEGIN
	DROP Procedure spGlobalDataGetStringValue2
END
GO

CREATE Procedure spGlobalDataGetStringValue2
	@KeyName			nvarchar(50),
	@StringValue        nvarchar(1000) OUTPUT
AS
BEGIN
	SELECT @StringValue = StringValue
	FROM GlobalData
	WHERE KeyName = @KeyName

END
GO

/*===============================================================
// Function: spGlobalDataUpdateIntegerValue
// Description:
//   Update an integer value in GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
//	 @Value					int
//=============================================================*/

PRINT 'Creating spGlobalDataUpdateIntegerValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataUpdateIntegerValue')
BEGIN
	DROP Procedure spGlobalDataUpdateIntegerValue
END
GO

CREATE Procedure spGlobalDataUpdateIntegerValue
	@KeyName			nvarchar(50),
	@Value				int
AS
BEGIN
	UPDATE GlobalData
	SET IntegerValue = @Value
	WHERE KeyName = @KeyName

	IF @@Rowcount < 1 
	BEGIN
		RAISERROR('No such GlobalData value with requested key', 16, 1)
	END
END
GO

/*===============================================================
// Function: spGlobalDataUpdateNumericValue
// Description:
//   Update a numeric value in GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
//	 @Value					decimal(10,2)
//=============================================================*/

PRINT 'Creating spGlobalDataUpdateNumericValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataUpdateNumericValue')
BEGIN
	DROP Procedure spGlobalDataUpdateNumericValue
END
GO

CREATE Procedure spGlobalDataUpdateNumericValue
	@KeyName			nvarchar(50),
	@Value				decimal(10,2)
AS
BEGIN
	UPDATE GlobalData
	SET NumericValue = @Value
	WHERE KeyName = @KeyName

	IF @@Rowcount < 1 
	BEGIN
		RAISERROR('No such GlobalData value with requested key', 16, 1)
	END
END
GO

/*===============================================================
// Function: spGlobalDataUpdateDateValue
// Description:
//   Update a datetime value in GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
//	 @Value					datetime
//=============================================================*/

PRINT 'Creating spGlobalDataUpdateDateValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataUpdateDateValue')
BEGIN
	DROP Procedure spGlobalDataUpdateDateValue
END
GO

CREATE Procedure spGlobalDataUpdateDateValue
	@KeyName			nvarchar(50),
	@Value				datetime
AS
BEGIN
	UPDATE GlobalData
	SET DateValue = @Value
	WHERE KeyName = @KeyName

	IF @@Rowcount < 1 
	BEGIN
		RAISERROR('No such GlobalData value with requested key', 16, 1)
	END
END
GO

/*===============================================================
// Function: spGlobalDataUpdateStringValue
// Description:
//   Update a string value in GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
//	 @Value					datetime
//=============================================================*/

PRINT 'Creating spGlobalDataUpdateStringValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataUpdateStringValue')
BEGIN
	DROP Procedure spGlobalDataUpdateStringValue
END
GO

CREATE Procedure spGlobalDataUpdateStringValue
	@KeyName			nvarchar(50),
	@Value				nvarchar(1000)
AS
BEGIN
	UPDATE GlobalData
	SET StringValue = @Value
	WHERE KeyName = @KeyName

	IF @@Rowcount < 1 
	BEGIN
		RAISERROR('No such GlobalData value with requested key', 16, 1)
	END
END
GO

/*===============================================================
// Function: spGlobalDataDeleteValue
// Description:
//   Delete a value of any type from GlobalData
// --------------------------------------------------------------
// Parameters
//	 @KeyName				nvarchar(50)
//=============================================================*/

PRINT 'Creating spGlobalDataDeleteValue...'
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGlobalDataDeleteValue')
BEGIN
	DROP Procedure spGlobalDataDeleteValue
END
GO

CREATE Procedure spGlobalDataDeleteValue
	@KeyName			nvarchar(50)
AS
BEGIN
	DELETE GlobalData
	WHERE KeyName = @KeyName

	IF @@Rowcount < 1 
	BEGIN
		RAISERROR('No such GlobalData value with requested key', 16, 1)
	END
END
GO

PRINT '== Finished createGlobalDataStoredProcs.sql =='
GO
  