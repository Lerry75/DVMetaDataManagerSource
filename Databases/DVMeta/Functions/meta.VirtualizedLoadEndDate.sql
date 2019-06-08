CREATE FUNCTION [meta].[VirtualizedLoadEndDate] ()
RETURNS bit
AS
BEGIN
	RETURN (SELECT CONVERT(BIT, LTRIM([Value])) FROM meta.[Configuration] WHERE Id = 'VirtualizedLoadEndDate');
END
