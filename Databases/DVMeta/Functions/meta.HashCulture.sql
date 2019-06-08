CREATE FUNCTION [meta].[HashCulture] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT [Value] FROM meta.[Configuration] WHERE Id = 'HashCulture');
END