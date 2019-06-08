CREATE FUNCTION [meta].[LegacyNonUnicodeInputForHash] ()
RETURNS bit
AS
BEGIN
  DECLARE @Value BIT = (SELECT CONVERT(BIT, LTRIM([Value])) FROM meta.[Configuration] WHERE Id = 'LegacyNonUnicodeInputForHash');
	
  RETURN ISNULL(@Value, 0);
END
