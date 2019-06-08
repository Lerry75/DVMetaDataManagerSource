CREATE FUNCTION [meta].[WarehouseRawSchema] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT CONCAT('[', [Value], ']') FROM meta.[Configuration] WHERE Id = 'WarehouseRawSchema');
END
