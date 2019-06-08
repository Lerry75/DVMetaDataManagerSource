CREATE FUNCTION [meta].[CurrentEnvironment] ()
RETURNS varchar(50)
AS
BEGIN
	DECLARE @Environment varchar(50) = (SELECT [Value] FROM meta.Environment WHERE [Id] = 'Environment');

	RETURN ISNULL(@Environment, 'Unknown');
END