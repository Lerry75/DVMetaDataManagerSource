CREATE FUNCTION [meta].[CurrentSchemaVersion] ()
RETURNS varchar(50)
AS
BEGIN
	DECLARE @SchemaVersion varchar(50) = (SELECT [Value] FROM meta.Environment WHERE [Id] = 'SchemaVersion');

	RETURN ISNULL(@SchemaVersion, 'Unknown');
END