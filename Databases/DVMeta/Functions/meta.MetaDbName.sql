CREATE FUNCTION [meta].[MetaDbName] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN CONCAT('[', DB_NAME(), ']');
END