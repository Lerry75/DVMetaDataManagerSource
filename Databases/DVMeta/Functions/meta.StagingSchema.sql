CREATE FUNCTION [meta].[StagingSchema] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT CONCAT('[', [Value], ']') FROM meta.[Configuration] WHERE Id = 'StagingSchema');
END
