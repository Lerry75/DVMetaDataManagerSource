CREATE FUNCTION [meta].[WarehouseBusinessSchema] ()
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT CONCAT('[', [Value], ']') FROM meta.[Configuration] WHERE Id = 'WarehouseBusinessSchema');
END
