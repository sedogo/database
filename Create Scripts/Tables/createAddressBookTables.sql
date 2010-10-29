/*===============================================================
// Filename: createAddressBookTables.sql
// Date: 26/03/10
// --------------------------------------------------------------
// Description:
//   This file creates the address book table
// --------------------------------------------------------------
// Dependencies:
//   None
// --------------------------------------------------------------
// Original author: PRD 26/03/10
// Revision history:
//=============================================================*/

PRINT '== Starting createAddressBookTables.sql =='

/*===============================================================
// Table: AddressBook
//=============================================================*/

PRINT 'Creating AddressBook...'

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'AddressBook')
	BEGIN
		DROP Table AddressBook
	END
GO

CREATE TABLE AddressBook
(
	AddressBookID						int					NOT NULL PRIMARY KEY IDENTITY,
	UserID								int					NOT NULL,
	FirstName			                nvarchar(200)		NULL,
	LastName			                nvarchar(200)		NULL,
	EmailAddress		                nvarchar(200)		NULL
)
GO

PRINT '== Finished createAddressBookTables.sql =='
 