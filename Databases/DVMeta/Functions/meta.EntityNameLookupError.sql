CREATE FUNCTION [meta].[EntityNameLookupError]
(
	@EntityId int
)
RETURNS varchar(50)
AS
BEGIN
	RETURN (SELECT CONCAT(EntityName, '_Lookup') FROM meta.EDWEntity WHERE EntityId = @EntityId);
END
