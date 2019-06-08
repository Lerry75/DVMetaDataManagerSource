CREATE FUNCTION [meta].[HashDelimiter] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT [Value] FROM meta.[Configuration] WHERE Id = 'HashDelimiter');
END