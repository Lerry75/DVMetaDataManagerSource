CREATE FUNCTION [meta].[DisabledForeignKey] ()
RETURNS bit
AS
BEGIN
	RETURN (SELECT CONVERT(BIT, LTRIM([Value])) FROM meta.[Configuration] WHERE Id = 'DisabledForeignKey');
END
