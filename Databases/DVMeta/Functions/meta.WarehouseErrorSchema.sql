CREATE FUNCTION [meta].[WarehouseErrorSchema] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT CONCAT('[', [Value], ']') FROM meta.[Configuration] WHERE Id = 'WarehouseErrorSchema');
END
