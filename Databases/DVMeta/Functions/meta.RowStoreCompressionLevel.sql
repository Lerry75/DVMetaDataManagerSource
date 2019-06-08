CREATE FUNCTION [meta].[RowStoreCompressionLevel] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT CASE CONVERT(BIT, LTRIM([Value])) WHEN 1 THEN 'ROW' ELSE 'NONE' END FROM meta.[Configuration] WHERE Id = 'CompressRowStore');
END
