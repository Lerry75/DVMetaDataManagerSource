CREATE FUNCTION [meta].[HashAlgorithm] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT [Value] FROM meta.[Configuration] WHERE Id = 'HashAlgorithm');
END