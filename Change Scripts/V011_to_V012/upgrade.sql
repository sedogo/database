--Create Full-text index
--commit test

CREATE FULLTEXT CATALOG SedogoEventsCatalog;
CREATE UNIQUE INDEX UQ_Events ON dbo.[Events](EventId);
CREATE FULLTEXT INDEX ON dbo.[Events]
(
    EventName                       --Full-text index column name 
    Language 2057	--2057 is the LCID for British English
)
KEY INDEX UQ_Events ON SedogoEventsCatalog 	--Unique index
WITH CHANGE_TRACKING AUTO            			--Population type;
GO
